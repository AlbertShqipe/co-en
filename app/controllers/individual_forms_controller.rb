class IndividualFormsController < ApplicationController
  require 'cloudinary'
  before_action :authenticate_user!

  def show
      if current_user.admin?
        @individual_form = IndividualForm.find(params[:id]) # Admins can access any duo
      else
        @individual_form = current_user.individual_forms.find(params[:id]) # Competitors can access only their own duos
      end

    @results = []
    IndividualForm.order(created_at: :asc).all.each_with_index do |solo, index|
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
    @results = []
    @individual_forms = IndividualForm.order(created_at: :asc)
    IndividualForm.order(created_at: :asc).each_with_index do |solo, index|
      @results << {
        count: index + 1,
        id: solo.id,
      }
    end

    @current_user = current_user

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

    @individual_forms_filter = IndividualForm.by_category(params[:category])
                                              .by_style(params[:style])
                                              .by_level(params[:level])
                                              .after_date(params[:start_date]) if params[:start_date].present?

                                              # Filter by multiple categories
    if params[:category].present?
      @individual_forms = @individual_forms.where(category: params[:category])
    end

    # Filter by multiple styles
    if params[:style].present?
      @individual_forms = @individual_forms.where(style: params[:style])
    end

    # Filter by multiple levels
    if params[:level].present?
      @individual_forms = @individual_forms.where(level: params[:level])
    end

    # # Filter by date
    if params[:start_date].present?
      @individual_forms = @individual_forms.where("created_at >= ?", params[:start_date])
    end
  end

  def new
    @individual_form = IndividualForm.new
  end

  def create
    # year = params.dig(:individual_form, 'birth_date(1i)')
    # month = params.dig(:individual_form, 'birth_date(2i)')
    # day = params.dig(:individual_form, 'birth_date(3i)')

    # birth_date = Date.new(year.to_i, month.to_i, day.to_i) if year && month && day

    @individual_form = current_user.individual_forms.new(individual_form_params)

    if @individual_form.save
      notice_message = I18n.t('individual_form.create.success')
      NotificationMailer.new_application_email(@individual_form).deliver_now
      redirect_to confirmation_form_path, notice: notice_message
    else
      alert_message1 = I18n.t('individual_form.create.error')
      render :new, alert: alert_message1
    end
  end

  def edit
    @individual_form = IndividualForm.find(params[:id])

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
    @individual_form = IndividualForm.find(params[:id])
    if @individual_form.update(individual_form_params)
      flash[:notice] = t('edit.flash_messages.success')
      redirect_to individual_form_path(@individual_form)
    else
      flash.now[:alert] = t('edit.flash_messages.error')
      render :edit, status: :unprocessable_entity
    end
  end

  def info
    def calculate_age(birthdate)
      birthdate = birthdate.is_a?(String) ? Date.parse(birthdate) : birthdate

      # Calculate the age based on the day of the competition
      reference_date = Date.new(2025, 4, 19)

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

    @solo = IndividualForm.find(params[:id])
    @results = []
    IndividualForm.order(created_at: :asc).all.each_with_index do |solo, index|
      @results << {
        count: index + 1,
        id: solo.id,
      }
    end

    render json: {
      id: @solo.id,
      name: @solo.first_name,
      last_name: @solo.last_name,
      birth_date: I18n.l(@solo.birth_date, format: :long, locale: :fr), # This will translate the date to French,
      age_day_competition: calculate_age(@solo.birth_date.strftime("%Y-%m-%d")),
      years: @solo.birth_date.strftime("%B %d, %Y"),
      address: @solo.address,
      phone: @solo.phone,
      email: @solo.email,
      teacher_name: @solo.teacher_name,
      teacher_phone: @solo.teacher_phone,
      teacher_email: @solo.teacher_email,
      dance_school: @solo.dance_school,
      category: @solo.category,
      style: @solo.style,
      level: @solo.level,
      photo: @solo.photo.key,
      file: @solo.file,
      id_card: @solo.id_card,
      solos_list: @results
    }

    rescue ActiveRecord::RecordNotFound
      render json: { error: "Solo not found" }, status: :not_found
  end

  private

  def individual_form_params
    params.require(:individual_form).permit(:first_name, :last_name, :birth_date, :address, :phone, :email, :teacher_name, :dance_school, :teacher_phone, :teacher_email, :category, :style, :level, :photo, :file, :id_card)
  end
end
