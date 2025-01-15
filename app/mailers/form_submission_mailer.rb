class FormSubmissionMailer < ApplicationMailer
  def solo_submission(solo)
    @solo = solo
    @user =  solo.user
    @url = 'https://www.concours-entrelace.com/users/sign_in?locale=fr'
    mail(
      to: solo.user.email, # Or the recipient's email
      subject: "Confirmation de soumission du formulaire Individuel"
    )
  end

  def duo_submission(duo)
    @duo = duo
    @user =  duo.user
    @url = 'https://www.concours-entrelace.com/users/sign_in?locale=fr'
    mail(
      to: duo.user.email,
      subject: "Confirmation de soumission du formulaire de Duo"
    )
  end

  def trio_submission(trio)
    @trio = trio
    mail(
      to: trio.user.email,
      subject: "Confirmation de soumission du formulaire de Trio"
    )
  end

  def group_submission(group)
    @group = group
    mail(
      to: group.user.email,
      subject: "Confirmation de soumission du formulaire de Groupe"
    )
  end
end
