class DocMailer < ApplicationMailer
  def send_signature_doc(to:, signing_request:)
    attachments["signature_doc.pdf"] = signing_request.signature_document.download
    mail(to: to, subject: "signature doc", body: "See attached")
  end
end