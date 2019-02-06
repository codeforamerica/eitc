class EitcEstimate < ApplicationRecord
  include EitcCalculator

  def refund
    calculate_eitc_refund(status: status, children: children, income: income)
  end

  def complete?
    status.present? && children.present? && income.present?
  end

  def analytics_data
    {
      filing_status: status,
      children: children.present? ? children.to_s : 'unknown',
      income: income.present? ? income : nil,
      eligible: complete? ? (refund > 0).to_s : 'unknown',
      refund: complete? ? refund : nil
    }
  end
end
