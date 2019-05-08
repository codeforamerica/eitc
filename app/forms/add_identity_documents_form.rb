class AddIdentityDocumentsForm < Form
  set_attributes_for :vita_client, identity_documents: []

  def save
    self.identity_documents ||= []
    documents_to_attach = identity_documents.reject do |document_signed_id|
      document_signed_id.blank? ||
          record.identity_documents.map(&:signed_id).include?(document_signed_id)
    end
    record.identity_documents.attach(documents_to_attach)
    record.identity_documents.each do |document|
      document.delete if identity_documents.exclude?(document.signed_id)
    end
  end

  def self.existing_attributes(record)
    {
        identity_documents: record.identity_documents
    }
  end

end