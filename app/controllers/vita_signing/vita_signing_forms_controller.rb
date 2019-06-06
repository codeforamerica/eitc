module VitaSigning
  class VitaSigningFormsController < ApplicationController
    before_action :ensure_valid_signing_request

    helper_method :current_signing_request, :step_count, :current_step, :current_path, :next_path, :form_name

    delegate :form_name, to: :class

    layout "vita_signing/form_card"

    def index
    end

    def destroy
    end

    def edit
      @form = form_class.from_record(current_record)
    end

    def update
      @form = form_class.new(current_record, form_params)
      if @form.valid?
        @form.save
        update_session
        track_form_progress
        redirect_to(next_path)
      else
        track_validation_errors
        render :edit
      end
    end

    def current_path(params = nil)
      vita_signing_path(self.class.to_param, params)
    end

    def next_path(params = {})
      next_step = form_navigation.next
      if next_step
        vita_signing_path(next_step.to_param, params)
      end
    end

    def self.show?(vita_client)
      true
    end

    def current_record
      current_signing_request
    end

    def current_signing_request
      SigningRequest.find_by(unique_key: signing_request_key)
    end

    def signing_request_key
      if params.has_key?(:unique_key)
        session[:signing_request_key] = params[:unique_key]
      end

      session[:signing_request_key]
    end

    def step_count
      5
    end

    private

    delegate :form_class, to: :class

    # Override in subclasses

    def update_session; end

    def current_step; end

    def form_params
      params.fetch(form_name, {}).permit(*form_class.attribute_names)
    end

    # Don't override in subclasses
    def ensure_valid_signing_request
      if current_signing_request.blank? || current_signing_request.expired?
        redirect_to invalid_signing_request_vita_signing_index_path
      end
    end

    def clear_session
      reset_session
    end

    def form_navigation
      @form_navigation ||= VitaSigningNavigation.new(self)
    end

    def track_form_progress
      send_mixpanel_event(
          event_name: @form.class.analytics_event_name,
          data: @form.record.analytics_data
      )
    end

    def track_validation_errors
      send_mixpanel_event(
        event_name: @form.class.analytics_event_name,
        data: {
          errors: @form.errors.messages.keys
        }
      )
    end

    class << self
      def to_param
        controller_name.dasherize
      end

      def form_name
        controller_name + "_form"
      end

      def form_class
        form_name.classify.constantize
      end
    end
  end
end

