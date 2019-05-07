module ResearchSignup
  class ChildrenController < ResearchSignupFormsController
    def current_step
      2
    end

    def next_path
      return offboarding_research_index_path unless current_eitc_estimate.has_children?
      super
    end
  end
end
