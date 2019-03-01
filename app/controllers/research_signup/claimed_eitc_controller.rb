module ResearchSignup
  class ClaimedEitcController < ResearchSignupFormsController
    def current_step
      5
    end

    def next_path
      return offboarding_research_index_path if current_eitc_estimate.in_gap? == false
      super
    end
  end
end
