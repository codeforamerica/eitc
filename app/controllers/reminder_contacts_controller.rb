class ReminderContactsController < ApplicationController
  layout "form_card"

  def new
    @reminder_contact = @form = ReminderContact.new
  end

  def create
    @reminder_contact = @form = ReminderContact.new(model_params)

    if @reminder_contact.save
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