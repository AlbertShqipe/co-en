class NotificationMailer < ApplicationMailer
  default from: 'concours.entrelace@gmail.com'

  def new_application_email(application)
    @application = application
    mail(
      to: 's.kiblade@icloud.com', # Replace with the desired recipient email
      subject: 'New Application Submitted'
    )
  end
end
