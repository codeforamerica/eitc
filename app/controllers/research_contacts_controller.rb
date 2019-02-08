class ResearchContactsController < ApplicationController
  layout "form_card"

  def new
    @research_contact = @form = ResearchContact.new
  end

  def create
    @research_contact = @form = ResearchContact.new(model_params.merge(visitor_id: visitor_id))

    if @research_contact.save
      send_mixpanel_event(
          event_name: "research_sign_up",
          data: {
            prefers_email: @form.email.present?,
            prefers_phone: @form.phone_number.present?
          })
      redirect_to thanks_research_contact_path
    else
      render 'new'
    end
  end

  def invitation
  end

  def thanks
  end

  def model_params
    params.require(:research_contact).permit(:email, :phone_number, :full_name)
  end
end