module ResearchSignup
  class FilingStatusController < ResearchSignupFormsController
    skip_before_action :ensure_eitc_estimate_present

    def current_eitc_estimate
      EitcEstimate.find_by(visitor_id: visitor_id) || EitcEstimate.new(visitor_id: visitor_id)
    end

    def current_step
      1
    end
  end
end
