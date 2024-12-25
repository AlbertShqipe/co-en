class NotificationMailer < ApplicationMailer
  default from: 's.kiblade@icloud.com'

  def new_application_email(application)
    @application = application
    mail(
      to: 's.kiblade@hotmail.it', # Replace with the desired recipient email
      subject: 'New Application Submitted'
    )
  end
end
