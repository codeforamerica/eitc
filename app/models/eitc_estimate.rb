class EitcEstimate < ApplicationRecord
  include EitcCalculator

  def refund
    calculate_eitc_refund(status: status, children: children, income: income)
  end
end
