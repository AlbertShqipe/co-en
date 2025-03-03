class WelcomeMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    @url = 'https://www.concours-entrelace.com/users/sign_in' # Adjust to your login URL

    # Attach the image
    # attachments.inline['LogoFullOrange1.png'] = File.read(Rails.root.join('app/assets/images/LogoFullOrange1.png'))

    mail(
      to: @user.email,
      bcc: "concours.entrelace@gmail.com, albert_nikolli@icloud.com",
      subject: 'Bienvenue au Concours Entrelacé!'
    )
  end
end
