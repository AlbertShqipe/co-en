class GroupFormsController < ApplicationController
  before_action :authenticate_user!

  def show
    if current_user.admin?
      @group_form = GroupForm.find(params[:id]) # Admins can access any group form
    else
      @group_form = current_user.group_forms.find(params[:id])
    end

    @results = []
    GroupForm.order(created_at: :asc).all.each_with_index do |solo, index|
      @results << {
        count: index + 1,
        id: solo.id,
      }
    end


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
    # raise
  end

  def index
    @group_forms = GroupForm.order(created_at: :asc)
    @group_form = current_user.group_forms.find(params[:id]) if params[:id].present?

    @results = []
    GroupForm.order(created_at: :asc).each_with_index do |solo, index|
      @results << {
        count: index + 1,
        id: solo.id,
      }
    end

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
    # raise

    @groups_filter = GroupForm.by_discipline(params[:discipline])
                              .by_level(params[:level])
                              .after_date(params[:start_date]) if params[:start_date].present?

    # Filter by multiple styles
    if params[:discipline].present?
      @group_forms = @group_forms.where(discipline: params[:discipline])
    end

    # Filter by multiple levels
    if params[:level].present?
      @group_forms = @group_forms.where(level: params[:level])
    end

    # # Filter by date
    if params[:start_date].present?
      @group_forms = @group_forms.where("created_at >= ?", params[:start_date])
    end
  end

  def new
    @group_form = GroupForm.new
    @group_form.participants.build
  end

  def create
    @group_form = GroupForm.new(group_form_params)
    @group_form.user_id = current_user.id
    if @group_form.participants.size < 4
      alert_message = I18n.t('group_form.create.participant_requirement')
      redirect_to new_group_form_path, alert: alert_message
    elsif @group_form.save
      notice_message = I18n.t('group_form.create.success')
      redirect_to confirmation_form_path, notice: notice_message
      SubscriptionMailer.notify_admin(@group_form, "Group").deliver_later
    else
      Rails.logger.debug @group_form.errors.full_messages
      flash[:alert] = I18n.t('individual_form.create.error')
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @group_form = GroupForm.includes(:participants).find(params[:id])

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
    # raise
  end

  def update
    @group_form = GroupForm.find(params[:id])
    if @group_form.update(group_form_params)
      redirect_to @group_form, notice: 'Group form updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def info
    def calculate_age(birthdate)
      birthdate = birthdate.is_a?(String) ? Date.parse(birthdate) : birthdate

      # Calculate the age based on the day of the competition
      reference_date = Date.new(2026, 4, 19)

      # Calculate the age based on today's date
      # today = Date.today
      # You change the reference_date to today to calculate the age based on today's date


      years = reference_date.year - birthdate.year
      months = reference_date.month - birthdate.month
      days = reference_date.day - birthdate.day

      if days < 0
        months -= 1
        previous_month = reference_date.prev_month
        days += (Date.new(previous_month.year, previous_month.month, -1).day)
      end

      if months < 0
        years -= 1
        months += 12
      end

      age_string = "#{years} #{t("helper.age_function_years")}"
      age_string += ", #{months} #{t("helper.age_function_months")}" if months > 0
      age_string += ", #{days} #{t("helper.age_function_days")}" if days > 0
      age_string += " #{t("helper.old")}"

      age_string
    end

    @group_form = GroupForm.find(params[:id])
    total_age = @group_form.participants.sum { |participant| participant.age }
    participant_count = @group_form.participants.size
    average_age = participant_count > 0 ? total_age.to_f / participant_count : 0
    average_age.round(2)
    @results = []
    GroupForm.all.each_with_index do |group, index|
      @results << {
        count: index + 1,
        id: group.id,
      }
    end
    render json: {
      id: @group_form.id,
      name: @group_form.name,
      responsable: @group_form.responsable,
      address: @group_form.address,
      phone: @group_form.phone,
      email: @group_form.email,
      discipline: @group_form.discipline,
      level: @group_form.level,
      title_of_music: @group_form.title_of_music,
      composer: @group_form.composer,
      length_of_piece: @group_form.length_of_piece,
      average_age: average_age.round(2),
      group_lists: @results,
      participants: @group_form.participants.map { |participant| { id: participant.id,
                                                                    name: participant.name,
                                                                    last_name: participant.last_name,
                                                                    birth_date:  I18n.l(participant.birth_date, format: :long, locale: :fr), # This will translate the date to French,,
                                                                    age_day_competition: calculate_age(participant.birth_date.strftime("%Y-%m-%d")),
                                                                    age: participant.age,
                                                                    # photo: participant.photo.key,
                                                                    file: participant.file,
                                                                    id_card: participant.id_card }
                                                                  }
    }
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Group not found" }, status: :not_found
  end

  private

  def group_form_params
    params.require(:group_form).permit(
      :name, :responsable, :address, :phone, :email,
      :title_of_music, :composer, :length_of_piece,
      :discipline, :level,
      participants_attributes: [
        :id, :name, :last_name, :birth_date, :age,
        :file, :id_card, :_destroy
        # :photo, :file, :id_card, :_destroy
      ]
    )
  end
end
