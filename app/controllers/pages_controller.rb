class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :regulation, :media, :who_we_are, :practical_info, :contact, :our_partners ]
  before_action :admin_only, only: [:messages] # Restrict access to certain actions

  def messages
    @messages = Message.all
  end

  def profile
    @groups = current_user.group_forms
    @group = current_user.group_forms.find(params[:id]) if params[:id].present?
    respond_to do |format|
      format.html # for regular HTML requests
      format.js   # for AJAX requests$
    end
  end

  def home
  end


  def regulation
  end

  def media
    @images_2023 = Cloudinary::Api.resources(type: "upload", prefix: "production/dance_images/2023", max_results: 500)['resources']
    @images_2024 = Cloudinary::Api.resources(type: "upload", prefix: "production/dance_images/2024", max_results: 500)['resources']
    @images_2025 = Cloudinary::Api.resources(type: "upload", prefix: "production/dance_images/2025", max_results: 500)['resources']
    # raise
    # @images = ['affiche_2025.png', 'DA1.jpg', 'espaceAlbertCamus1.jpeg']
  end

  def who_we_are
  end

  def practical_info
  end

  def contact
  end

  def our_partners
  end

  def apply
  end

  def contact
  end

  def admin
    @users = User.all
    @user = User.find(params[:id]) if params[:id].present?
    @groups = GroupForm.all
    @group = GroupForm.find(params[:id]) if params[:id].present?
    @duos = Duo.all
    @duo = Duo.find(params[:id]) if params[:id].present?
    @trios = Trio.all
    @trios = Trio.find(params[:id]) if params[:id].present?
    @solos = IndividualForm.all
    @solo = IndividualForm.find(params[:id]) if params[:id].present?
    respond_to do |format|
      format.html # for regular HTML requests
      format.js   # for AJAX requests$
    end
  end

  private

  # Check if the user has the 'admin' role
  def admin_only
    unless current_user.admin?
      flash[:alert] = "Access denied. Admins only."
      redirect_to(root_path) # Redirect to a safe page, e.g., home page
    end
  end
end
