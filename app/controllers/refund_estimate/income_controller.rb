module RefundEstimate
  class IncomeController < EitcEstimateFormsController
    def current_step
      5
    end

    def next_path
      return invitation_research_contact_path if current_eitc_estimate.in_gap?
      super + '#result'
    end
  end
end
