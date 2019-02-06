class ReminderContactsController < ApplicationController
  layout "form_card"

  def new
    @reminder_contact = @form = ReminderContact.new
  end

  def create
    @reminder_contact = @form = ReminderContact.new(model_params.merge(visitor_id: visitor_id))

    if @reminder_contact.save
      send_mixpanel_event(
          event_name: "reminder_sign_up",
          data: {
            prefers_email: @form.email.present?,
            prefers_phone: @form.phone_number.present?
          })
      redirect_to thanks_reminder_contact_path
    else
      render 'new'
    end
  end

  def thanks
  end

  def model_params
    params.require(:reminder_contact).permit(:email, :phone_number)
  end
end