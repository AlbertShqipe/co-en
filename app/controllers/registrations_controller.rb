class RegistrationsController < Devise::RegistrationsController
  private

  # If you want to permit additional parameters for sign up
  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :last_name, :photo)
  end

  # If you want to permit additional parameters for account update
  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :name, :last_name, :photo)
  end
end
