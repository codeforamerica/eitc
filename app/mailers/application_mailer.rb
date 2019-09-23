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

  def vita_signing_confirmation(email)
    mail(
        from: %("Code for America VITA Support" <vita-support@codeforamerica.org>),
        to: email,
        subject: "Confirmation of receipt of your signed tax returns",
        )
  end

  def vita_signing_request(signing_request:)
    @signing_request = signing_request

    mail(
        from: %("Code for America VITA Support" <vita-support@codeforamerica.org>),
        to: @signing_request.vita_client.email,
        subject: "Your #{@signing_request.year} tax return is ready",
        )
  end
end
