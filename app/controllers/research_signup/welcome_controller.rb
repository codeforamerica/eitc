module ResearchSignup
  class WelcomeController < ResearchSignupFormsController
    skip_before_action :ensure_eitc_estimate_present

    def form_class
      NullForm
    end

    def current_step
      1
    end
  end
end
