module VitaIntake
  class WhichYearsController < VitaIntakeFormsController
    skip_before_action :ensure_vita_client_present

    def current_vita_client
      VitaClient.find_by(visitor_id: visitor_id) ||
          VitaClient.new(visitor_id: visitor_id, source: source, state: state, referrer: referrer)
    end
  end
end
