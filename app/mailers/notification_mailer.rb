class NotificationMailer < ApplicationMailer
  default from: 'no-reply@concours-entrelace.com'

  def new_application_email(application)
    @application = application
    mail(
      to: 's.kiblade@icloud.it', # Replace with the desired recipient email
      subject: 'reset password'
    )
  end
end
