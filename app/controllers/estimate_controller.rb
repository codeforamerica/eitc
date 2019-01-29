class EstimateController < EitcEstimateFormsController
  include EitcCalculator

  helper_method :refund_amount

  def refund_amount
    calculate_eitc_refund(
        status: current_eitc_estimate.status,
        children: current_eitc_estimate.children,
        income: current_eitc_estimate.income
    )
  end

  def form_class
    NullForm
  end
end