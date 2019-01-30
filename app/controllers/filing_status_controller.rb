class FilingStatusController < EitcEstimateFormsController
  skip_before_action :ensure_eitc_estimate_present

  layout "hero"

  def update_session
    session[:current_eitc_estimate_id] = @form.record.id
  end

  def current_eitc_estimate
    EitcEstimate.find_by(id: session[:current_eitc_estimate_id]) || EitcEstimate.new
  end

  def current_step
    1
  end
end