class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def vita_intake_confirmation(email)
    mail(
        from: %("Code for America VITA Support" <vita-support@codeforamerica.org>),
        to: email,
        subject: "Confirmation of receipt of your tax documents",
        )
  end

  def vita_approval_confirmation(email)
    mail(
        from: %("Code for America VITA Support" <vita-support@codeforamerica.org>),
        to: email,
        subject: "Confirmation of receipt of your approval to file",
        )
  end

  def vita_signing_request(email, link)
    @signing_request_link = link

    mail(
        from: %("Code for America VITA Support" <vita-support@codeforamerica.org>),
        to: email,
        subject: "Your tax returns are ready",
        )
  end
end
