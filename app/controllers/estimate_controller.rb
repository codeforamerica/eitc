class EstimateController < EitcEstimateFormsController
  layout "hero"

  def form_class
    NullForm
  end
end