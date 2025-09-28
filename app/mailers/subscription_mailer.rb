class SubscriptionMailer < ApplicationMailer
  def notify_admin(subscription, type)
    @subscription = subscription
    @type = type
    @url = 'https://www.concours-entrelace.com/users/sign_in?locale=fr'

    mail(
      bcc: "concours.entrelace@gmail.com",
      subject: "Nouvelle inscription : #{@type}"
    )
  end
end
