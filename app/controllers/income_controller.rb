class IncomeController < EitcEstimateFormsController
  def current_step
    3
  end

  def next_path
    super + '#result'
  end
end