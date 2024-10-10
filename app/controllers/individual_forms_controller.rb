class IndividualFormsController < ApplicationController
  require 'cloudinary'
  before_action :authenticate_user!

  def index
    @results = []
    @individual_forms = IndividualForm.all
    IndividualForm.all.each_with_index do |solo, index|
      @results << {
        count: index + 1,
        id: solo.id,
      }
    end

    @current_user = current_user
    # @results = Cloudinary::Api.resources(prefix: 'development', type: 'upload', max_results: 10)

    #   # Code that runs only in development since it charges the assets uploaded in development
      @results_dev = Cloudinary::Api.resources(type: "upload", prefix: "development", max_results: 500)['resources']

      # Code that shoul run only in production since it charges the assets uploaded in production
      @results_prod = Cloudinary::Api.resources(type: "upload", prefix: "production", max_results: 500)['resources']
    # raise

    @individual_forms_filter = IndividualForm.by_category(params[:category])
                                              .by_style(params[:style])
                                              .by_level(params[:level])

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
      redirect_to apply_path, notice: notice_message
    else
      alert_message1 = I18n.t('individual_form.create.error')
      render :new, alert: alert_message1
    end
  end

  def info
    @solo = IndividualForm.find(params[:id])
    @results = []
    IndividualForm.all.each_with_index do |solo, index|
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

  def individual_form_params
    params.require(:individual_form).permit(:first_name, :last_name, :birth_date, :address, :phone, :email, :teacher_name, :dance_school, :teacher_phone, :teacher_email, :category, :style, :level, :photo, :file, :id_card)
  end
end
