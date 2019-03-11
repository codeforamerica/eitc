class ResearchContactsController < ApplicationController
  layout "form_card"

  helper_method :phone_number_for_texting_clients

  def new
    @research_contact = @form = ResearchContact.new
  end

  def create
    @research_contact = @form = ResearchContact.new(model_params.merge(visitor_id: visitor_id, source: source))

    if @research_contact.save
      send_mixpanel_event(
          event_name: "research_sign_up",
          data: {
            prefers_email: @form.email.present?,
            prefers_phone: @form.phone_number.present?
          })
      NewResearchContactSlackNotificationJob.perform_later(research_contact: @research_contact)
      redirect_to thanks_research_contact_path
    else
      render 'new'
    end
  end

  def invitation
  end

  def thanks
  end

  def appointment
    @research_contact = ResearchContact.find_by(unique_token: params[:unique_token])
    if @research_contact
      calendly_url = @research_contact.appointment_url || CredentialsHelper.environment_credential_for_key(:calendly_url)
      calendly_params = {
          full_name: @research_contact.full_name,
          email: @research_contact.email,
          a1: @research_contact.phone_number
      }
      event_data = @research_contact.eitc_estimate&.analytics_data || {}
      send_mixpanel_event(
        event_name: "research_interview_link_click", unique_id: @research_contact.visitor_id, data: event_data)
      @research_contact.update(followed_interview_link: DateTime.now.utc, appointment_url: calendly_url)
      return redirect_to(calendly_url + "?" + calendly_params.to_query)
    end
  end

  def model_params
    params.require(:research_contact).permit(:email, :phone_number, :full_name)
  end

  def phone_number_for_texting_clients
    @phone_number ||= Phonelib.parse(
        Rails.application.credentials.dig(Rails.env.to_sym, :phone_number_for_texting_clients))
  end
end