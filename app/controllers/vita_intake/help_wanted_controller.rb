module VitaIntake
  class HelpWantedController < VitaIntakeFormsController
    def self.show?(vita_client)
      vita_client.already_filed?
    end
  end
end
