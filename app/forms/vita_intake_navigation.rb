class VitaIntakeNavigation
  MAIN = [
    VitaIntake::WelcomeController,
    VitaIntake::StepsOverviewController,
    VitaIntake::QuestionsOverviewController,
    VitaIntake::AboutYouController,
    VitaIntake::WhereDoYouLiveController,
    VitaIntake::ContactInfoController,
    VitaIntake::AreYouMarriedController,
    VitaIntake::AboutYourSpouseController,
    VitaIntake::AnyDependentsController,
    VitaIntake::DependentsOverviewController,
    VitaIntake::IdentityDocumentsOverviewController,
    VitaIntake::AddIdentityDocumentsController,
    VitaIntake::TaxDocumentsOverviewController,
    VitaIntake::AddTaxDocumentsController,
    # VitaIntake::AnyoneSelfEmployedController,
    VitaIntake::AnythingElseController,
    # VitaIntake::ReviewYourInformationController,
    # VitaIntake::ConsentAndSignController,
    VitaIntake::ConfirmationController,
  ].freeze

  OFF_MAIN = [
    VitaIntake::AddDependentController,
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
      form_controller_class.show?(@form_controller.current_vita_client)
    end
  end
end
