class EitcEstimate < ApplicationRecord
  include EitcCalculator

  FILED_RECENTLY_CHOICES = %w(unset yes no)
  CLAIMED_EITC_CHOICES = %w(unset yes no unsure)

  validates_inclusion_of :filed_recently, :in => FILED_RECENTLY_CHOICES
  validates_inclusion_of :claimed_eitc, :in => CLAIMED_EITC_CHOICES

  def eligible
    return unless eligibility_knowable?
    refund > 0
  end

  def refund
    calculate_eitc_refund(status: status, children: children, income: income)
  end

  def eligibility_knowable?
    status.present? && children.present? && income.present?
  end

  def gap_knowable?
    eligibility_knowable? && (filed_recently == 'no' || claimed_eitc != 'unset')
  end

  def in_gap?
    return unless gap_knowable?
    eligible && ( filed_recently == 'no' || ['no', 'unsure'].include?(claimed_eitc) )
  end

  def analytics_data
    {
      filing_status: status,
      children: children.present? ? children.to_s : 'unknown',
      income: income.present? ? income : nil,
      eligible: eligibility_knowable? ? (refund > 0).to_s : 'unknown',
      refund: eligibility_knowable? ? refund : nil,
      filed_recently: filed_recently == 'unset' ? 'unknown' : filed_recently,
      claimed_eitc: claimed_eitc == 'unset' ? 'unknown' : claimed_eitc,
      in_gap: gap_knowable? ? in_gap?.to_s : 'unknown'
    }
  end
end
