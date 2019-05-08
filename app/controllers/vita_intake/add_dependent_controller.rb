module VitaIntake
  class AddDependentController < VitaIntakeFormsController
    helper_method :member_id

    def update
      @form = form_class.new(form_params)
      if @form.valid?
        member.update!(form_params)
        track_form_progress
        redirect_to next_path
      else
        track_validation_errors
        render :edit
      end
    end

    private

    def member
      @member ||= find_or_initialize_member
    end

    def find_or_initialize_member
      if member_id.present?
        current_vita_client.dependents.find(id: member_id)
      else
        current_vita_client.household_members.build(relation: :dependent)
      end
    end

    def member_id
      @member_id ||= params[:member_id]
    end
  end
end
