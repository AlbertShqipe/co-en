class NotificationMailer < ApplicationMailer
  default from: 'MS_jErVDJ@concours-entrelace.com'

  def new_application_email(application)
    @application = application
    mail(
      to: 's.kiblade@icloud.it', # Replace with the desired recipient email
      subject: 'New Application Submitted'
    )
  end
end
