module ResearchSignup
  class IncomeController < ResearchSignupFormsController
    helper_method :married?

    def married?
      current_eitc_estimate.status == 'joint'
    end

    def current_step
      3
    end

    def next_path
      return offboarding_research_index_path if current_eitc_estimate.eligible == false
      super
    end
  end
end
