class FormNavigation
  MAIN = [
    FilingStatusController,
    ChildrenController,
    FiledRecentlyController,
    ClaimedEitcController,
    IncomeController,
    EstimateController
  ].freeze

  class << self
    delegate :first, to: :form_controllers

    def form_controllers
      MAIN
    end
  end

  delegate :form_controllers, to: :class

  def initialize(form_controller)
    @form_controller = form_controller
  end

  def next
    return unless index

    form_controllers_until_end = form_controllers[index + 1..-1]
    seek(form_controllers_until_end)
  end

  private

  def index
    form_controllers.index(@form_controller.class)
  end

  def seek(list)
    list.detect do |form_controller_class|
      form_controller_class.show?(@form_controller.current_eitc_estimate)
    end
  end
end
