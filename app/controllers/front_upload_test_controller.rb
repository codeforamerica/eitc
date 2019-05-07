class FrontUploadTestController < ApplicationController

  def new
  end

  def upload
    uploaded_io = params[:tax_doc]
    FrontService.instance.send_message_with_attachment(uploaded_io)
  end

end

