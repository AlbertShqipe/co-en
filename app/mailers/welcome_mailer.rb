class WelcomeMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    @url = 'https://www.concours-entrelace.com/users/sign_in' # Adjust to your login URL
    mail(
      to: @user.email,
      subject: 'Bienvenue au Concours Entrelacé!'
    )
  end
end
