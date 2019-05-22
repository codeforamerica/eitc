class ReadyForDocumentsForm < Form
  set_attributes_for :vita_client, :ready_to_submit_docs

  def save
    record.update(attributes_for(:vita_client))
  end
end