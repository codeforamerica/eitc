module EitcCalculator
  def calculate_eitc_refund(status:, children:, income:)
    params = parameters(children)
    rounded_wages = income == 0 ? 0 : (income / 50).floor * 50 + 25
    marriage_penalty_relief = status == "joint" ? params[:marriage_penalty_relief] : 0
    gross_eitc = [rounded_wages, params[:earned_income_base_amount]].min * params[:phase_in_rate]
    less_amount = [0, (rounded_wages - (params[:begin_phaseout] + marriage_penalty_relief)) * params[:phase_out_rate]].max
    [gross_eitc - less_amount, 0].max.round
  end

  private

  def parameters(children)
    case children
    when 0
      {
        earned_income_base_amount: 6670,
        begin_phaseout: 8340,
        marriage_penalty_relief: 5590,
        phase_in_rate: 0.0765,
        phase_out_rate: 0.0765
      }
    when 1
      {
        earned_income_base_amount: 10000,
        begin_phaseout: 18340,
        marriage_penalty_relief: 5590,
        phase_in_rate: 0.34,
        phase_out_rate: 0.1598
      }
    when 2
      {
        earned_income_base_amount: 14040,
        begin_phaseout: 18340,
        marriage_penalty_relief: 5590,
        phase_in_rate: 0.4,
        phase_out_rate: 0.2106
      }
    when 3
      {
        earned_income_base_amount: 14040,
        begin_phaseout: 18340,
        marriage_penalty_relief: 5590,
        phase_in_rate: 0.45,
        phase_out_rate: 0.2106
      }
    end
  end
end
