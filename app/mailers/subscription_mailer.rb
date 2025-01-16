class SubscriptionMailer < ApplicationMailer
  def notify_admin(subscription, type)
    @subscription = subscription
    @type = type
    @url = 'https://www.concours-entrelace.com/users/sign_in?locale=fr'

    admin_emails = User.where(role: :admin).pluck(:email)
    mail(
      bbc: admin_emails.join(", "),
      subject: "Nouvelle inscription : #{@type}"
    )
  end
end
