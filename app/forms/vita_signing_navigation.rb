class VitaSigningNavigation
  MAIN = [
    VitaSigning::WelcomeController,
    VitaSigning::FederalEfileController,
    VitaSigning::StateEfileController,
    VitaSigning::FileReturnsController,
    VitaSigning::ConfirmationController,
  ].freeze

  OFF_MAIN = [
      VitaSigning::InvalidSigningRequestController,
  ].freeze

  class << self
    delegate :first, to: :main_form_controllers

    def main_form_controllers
      MAIN
    end

    def all_form_controllers
      (MAIN + OFF_MAIN).freeze
    end
  end

  delegate :main_form_controllers, to: :class

  def initialize(form_controller)
    @form_controller = form_controller
  end

  def next
    return unless index

    form_controllers_until_end = main_form_controllers[index + 1..-1]
    seek(form_controllers_until_end)
  end

  private

  def index
    main_form_controllers.index(@form_controller.class)
  end

  def seek(list)
    list.detect do |form_controller_class|
      form_controller_class.show?(@form_controller.current_signing_request)
    end
  end
end
