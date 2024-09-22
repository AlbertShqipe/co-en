class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :regulation, :media, :who_we_are, :practical_info, :contact, :our_partners ]

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
end
