module ResearchSignup
  class FiledRecentlyController < ResearchSignupFormsController
    def current_step
      4
    end

    def next_path
      return offboarding_research_index_path unless current_eitc_estimate.eligible_for_at_least(100)
      super
    end
  end
end
