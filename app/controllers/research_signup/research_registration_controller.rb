module ResearchSignup
  class ResearchRegistrationController < ResearchSignupFormsController
    def current_record
      ResearchContact.find_by(visitor_id: visitor_id) || ResearchContact.new(visitor_id: visitor_id)
    end

    def current_step
      6
    end

    private

    def track_form_progress
      NewResearchContactSlackNotificationJob.perform_later(research_contact: current_record)
      send_mixpanel_event(
          event_name: @form.class.analytics_event_name,
          data: current_eitc_estimate.analytics_data
      )
      session.delete(:visitor_id)
    end
  end
end
