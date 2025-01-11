class NotificationMailer < ApplicationMailer
  default from: 'concours.entrelace@gmail.com'

  def new_application_email(application)
    @application = application
    mail(
      to: 's.kiblade@icloud.it', # Replace with the desired recipient email
      subject: 'reset password'
    )
  end
end
