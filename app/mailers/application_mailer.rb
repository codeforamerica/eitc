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
end
