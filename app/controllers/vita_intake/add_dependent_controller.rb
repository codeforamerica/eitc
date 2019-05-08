module VitaIntake
  class AddDependentController < VitaIntakeFormsController
    helper_method :member_id

    def current_record
      dependent
    end

    def next_path
      dependents_overview_vita_intake_index_path
    end

    private

    def dependent
      @dependent ||= find_or_initialize_dependent
    end

    def find_or_initialize_dependent
      if member_id.present?
        current_vita_client.dependents.find_by(id: member_id)
      else
        current_vita_client.household_members.build(relation: :dependent)
      end
    end

    def member_id
      @member_id ||= params[:member_id]
    end
  end
end
