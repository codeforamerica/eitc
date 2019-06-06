class HelpWantedForm < Form
  set_attributes_for :vita_client, :already_filed_needs

  validates_presence_of :already_filed_needs, message: "Make sure to tell us what kind of help you want."

  def save
    record.update(attributes_for(:vita_client))
  end
end