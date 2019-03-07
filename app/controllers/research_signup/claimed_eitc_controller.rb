module ResearchSignup
  class ClaimedEitcController < ResearchSignupFormsController
    def current_step
      5
    end

    def next_path
      return offboarding_research_index_path unless current_eitc_estimate.in_gap_for_at_least?(100)
      super
    end
  end
end
