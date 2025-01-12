class TestMailer < ApplicationMailer
  def test_email(recipient)
    from_email = "no-reply@concours-entrelace.com" # Replace with your verified domain email
    reply_to = "concours.entrelace@gmail.com" # Optional: Where replies should go

    mail(
      to: recipient,
      from: from_email,
      reply_to: reply_to,
      subject: 'Testing email for the Concours Entrelacé application',
      body: 'This is a test email to confirm your SMTP setup works.',
      content_type: 'text/plain'
    )
  end
end
