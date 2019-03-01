module ResearchSignup
  class IncomeController < ResearchSignupFormsController
    def current_step
      3
    end

    def next_path
      return offboarding_research_index_path if current_eitc_estimate.eligible == false
      super
    end
  end
end
