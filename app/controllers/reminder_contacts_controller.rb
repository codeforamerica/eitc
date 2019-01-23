class ReminderContactsController < ApplicationController
  def template_css_class
    'question'
  end

  def new
    @reminder_contact = ReminderContact.new
  end

  def create
    @reminder_contact = ReminderContact.new(model_params)

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