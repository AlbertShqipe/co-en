class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :regulation, :who_we_are, :practical_info, :contact, :our_partners, :confirmation_form ]
  before_action :admin_only, only: [:messages] # Restrict access to certain actions

  def messages
    @messages = Message.all
  end

  def test
    # Code that runs only in development since it charges the assets uploaded in development
    @results_dev = Cloudinary::Api.resources(type: "upload", prefix: "development", max_results: 500)['resources']

    # Code that should run only in production since it charges the assets uploaded in production
    response = Cloudinary::Api.resources(type: "upload", prefix: "production", max_results: 500)
    @results_prod = response['resources']

    if response['next_cursor']
      @results_prod_1 = Cloudinary::Api.resources(
        type: "upload",
        prefix: "production",
        max_results: 500,
        next_cursor: response['next_cursor']
      )['resources']
    else
      @results_prod_1 = []
    end

    @forms = []

    # Handling IndividualForm separately
    IndividualForm.all.each do |f|
      @forms << {
        type: "Individual",
        name: f.first_name,
        last_name: f.last_name,
        birth_date: f.birth_date,
        address: f.address,
        phone: f.phone,
        email: f.email,
        teacher_name: f.teacher_name,
        dance_school: f.dance_school,
        teacher_phone: f.teacher_phone,
        teacher_email: f.teacher_email,
        category: f.category,
        style: f.style,
        level: f.level,
        photo: f.photo&.key,  # Prevents error if photo is nil
        file: f.file&.key,    # Prevents error if file is nil
        id_card: f.id_card&.key,  # Prevents error if id_card is nil
        created_at: f.created_at,
        updated_at: f.updated_at
      }
    end

    # Handling DuoForm, TrioForm, and GroupForm with a shared structure
    [Duo, Trio, GroupForm].each do |form_class|
      form_class.all.each do |f|
        # Determine the participant association based on the form class
          participants_key =
          case form_class.name
          when "Duo"
            :duo_participants
          when "Trio"
            :trio_participants
          else
            :participants
          end

        @forms << {
          type: form_class.name,  # Saves "Duo", "Trio", or "GroupForm"
          name: f.name,
          responsable: f.responsable,
          address: f.address,
          phone: f.phone,
          email: f.email,
          discipline: f.discipline,
          level: f.level,
          title_of_music: f.title_of_music,
          composer: f.composer,
          length_of_piece: f.length_of_piece,
          user_id: f.user_id,
          created_at: f.created_at,
          updated_at: f.updated_at,
          participants: f.send(participants_key).map do |p|
            {
              first_name: p.name,  # Corrected: assuming participants have first_name
              last_name: p.last_name,
              birth_date: p.birth_date,
              age: p.age,
              photo: p.photo&.key,
              file: p.file&.key,
              id_card: p.id_card&.key
            }
          end
        }
      end
    end
  end

  def confirmation_form
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
