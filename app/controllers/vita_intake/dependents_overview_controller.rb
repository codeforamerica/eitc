module VitaIntake
  class DependentsOverviewController < VitaIntakeFormsController
    def self.show?(vita_client)
      vita_client.dependents?
    end

    def destroy
      if dependent.present?
        dependent.destroy
      end
      render :edit
    end

    def form_class
      NullForm
    end

    private

    def dependent
      @dependent = current_vita_client.dependents.find_by(id: member_id) if member_id.present?
    end

    def member_id
      @member_id ||= params[:member_id]
    end
  end
end
