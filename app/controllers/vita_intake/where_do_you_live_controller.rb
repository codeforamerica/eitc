module VitaIntake
  class WhereDoYouLiveController < VitaIntakeFormsController
    include StateChoices

    helper_method :state_choices
  end
end
