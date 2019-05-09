class AddTaxDocumentsForm < Form
  set_attributes_for :vita_client, tax_documents: []

  def save
    self.tax_documents ||= []
    documents_to_attach = tax_documents.reject do |document_signed_id|
      document_signed_id.blank? ||
          record.tax_documents.map(&:signed_id).include?(document_signed_id)
    end
    record.tax_documents.attach(documents_to_attach)
    record.tax_documents.each do |document|
      document.purge if tax_documents.exclude?(document.signed_id)
    end
  end

  def self.existing_attributes(record)
    {
        tax_documents: record.tax_documents
    }
  end

end