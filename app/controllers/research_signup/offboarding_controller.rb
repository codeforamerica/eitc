module ResearchSignup
  class OffboardingController < ResearchSignupFormsController
    def form_class
      NullForm
    end
  end
end
