module VitaSigning
  class WelcomeController < VitaSigningFormsController
    def form_class
      NullForm
    end
  end
end
