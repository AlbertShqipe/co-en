class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :regulation, :media, :who_are_we, :practical_info, :contact, :our_partners ]

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
    @images = [""]
  end

  def who_are_we
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
