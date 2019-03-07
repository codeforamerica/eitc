module RefundEstimate
  class IncomeController < EitcEstimateFormsController
    def current_step
      5
    end

    def next_path
      return invitation_research_contact_path if current_eitc_estimate.in_gap_for_at_least?(100)
      super + '#result'
    end
  end
end
