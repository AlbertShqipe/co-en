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
    @images = Cloudinary::Api.resources(type: "upload", prefix: "production/dance_images", max_results: 500)['resources']
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
end
