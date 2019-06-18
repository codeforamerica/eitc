class DocMailer < ApplicationMailer
  def send_docs(to:, signing_request:)
    attachments["signature_doc.pdf"] = signing_request.signature_document.download
    attachments["prepared_return.pdf"] = signing_request.prepared_return.download
    mail(to: to, subject: "docs", body: "See attached")
  end
end