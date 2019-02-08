class FiledRecentlyController < EitcEstimateFormsController
  def current_step
    3
  end

  def next_path
    return income_screens_path if current_eitc_estimate.filed_recently == 'no'
    super
  end
end