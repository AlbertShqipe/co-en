class TestMailer < ApplicationMailer
  def test_email(recipient)
    mail(
      to: recipient,
      subject: 'Test Email',
      body: 'This is a test email to confirm your SMTP setup works.',
      content_type: 'text/plain'
    )
  end
end
