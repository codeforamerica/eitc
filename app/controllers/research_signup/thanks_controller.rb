module ResearchSignup
  class ThanksController < ResearchSignupFormsController
    skip_before_action :ensure_eitc_estimate_present

    def form_class
      NullForm
    end
  end
end
