module VitaIntake
  class AboutYourSpouseController < VitaIntakeFormsController
    def self.show?(vita_client)
      vita_client.married?
    end
  end
end
