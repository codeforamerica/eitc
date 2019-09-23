module VitaSigning
  class StateEfileController < VitaSigningFormsController
    def self.show?(signing_request)
      available_state_returns = ["California", "Colorado"]
      available_state_returns.include? signing_request.vita_client.state
    end
  end
end
