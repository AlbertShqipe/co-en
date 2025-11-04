class IndividualFormsController < ApplicationController
  include ApplicationHelper
  include Rails.application.routes.url_helpers
  require 'cloudinary'
  require "open-uri"
  before_action :authenticate_user!
  before_action :prevent_new_submissions, only: [:new, :create]

  def show
    if current_user.admin?
      @individual_form = IndividualForm.find(params[:id]) # Admins can access any solo
    else
      @individual_form = current_user.individual_forms.find(params[:id]) # Competitors can access only their own solos
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

  def download_report
    @application = IndividualForm.find(params[:id])

    pdf = Prawn::Document.new


    # Candidate data
    full_name     = "#{@application.first_name} #{@application.last_name}"
    birth_date    = @application.birth_date
    age           = calculate_age(birth_date)
    address       = @application.address
    phone         = @application.phone
    email         = @application.email
    teacher_name  = @application.teacher_name
    teacher_phone = @application.teacher_phone
    teacher_email = @application.teacher_email
    dance_school  = @application.dance_school
    category      = @application.category
    style         = @application.style
    level         = @application.level

    # Logo header
    banner_height = 100
    logo_path = Rails.root.join("app/assets/images/LogoFullOrange1.png")
    if File.exist?(logo_path)
      y_position = pdf.cursor - (banner_height / 2) + 40
      pdf.image logo_path, width: 200, position: :left, at: [pdf.bounds.width / 2 - 100, y_position]
    end

    pdf.fill_color "000000"
    pdf.move_down banner_height + 10
    pdf.text "Fiche Candidat", size: 16, style: :bold, align: :center

    pdf.move_down 20
    pdf.text "Informations personnelles", size: 12, style: :bold
    pdf.move_down 10

    data = [
      ["Nom complet", "#{@application.first_name} #{@application.last_name}"],
      ["Date de naissance", @application.birth_date.strftime("%d/%m/%Y")],
      ["Âge", calculate_age(@application.birth_date)],
      ["Adresse", @application.address],
      ["Téléphone", @application.phone],
      ["Email", @application.email],
      ["École de danse", @application.dance_school],
      ["Enseignant.e", @application.teacher_name],
      ["Téléphone enseignant.e", @application.teacher_phone],
      ["Email enseignant.e", @application.teacher_email],
      ["Catégorie", @application.category],
      ["Style", @application.style],
      ["Niveau", @application.level]
    ]

    pdf.table(data, row_colors: ["F0F0F0", "FFFFFF"], cell_style: { padding: [5, 10], size: 10 }, width: pdf.bounds.width)
    pdf.move_down 30
    pdf.text "Rapport généré le #{Date.today.strftime('%d/%m/%Y')}", align: :right, size: 8

    if Rails.env.development?
      ### PAGE 2 — ID CARD
      if @application.id_card.attached?
        pdf.start_new_page
        pdf.text "Carte d'identité", size: 14, style: :bold
        pdf.move_down 30
        begin
          # Use Cloudinary's preview feature to convert first page of PDF to image
          # Use ActiveStorage key to build the Cloudinary image URL
          key = @application.id_card.key.sub(/\.\w+$/, '') # remove extension
          version = "v1761044962" # optional if you want to force a specific version

          cloud_name = Cloudinary.config.cloud_name
          preview_url = "https://res.cloudinary.com/#{cloud_name}/image/upload/#{version}/development/#{key}.png"

          preview_image = URI.open(preview_url)
          pdf.image preview_image, width: 450, position: :center
        rescue => e
          pdf.text "Impossible de charger l'aperçu de la carte : #{e.message}", size: 9, style: :italic, color: "ff0000"
        end
      else
        pdf.text "Carte d'identité non fournie", size: 10, style: :italic
      end

      ### PAGE 3 — OTHER FILE
      if @application.file.attached?
        pdf.start_new_page
        pdf.text "Formulaire d'Autorisation", size: 14, style: :bold
        pdf.move_down 30
        begin
          # Use Cloudinary's preview feature to convert first page of PDF to image
          # Use ActiveStorage key to build the Cloudinary image URL
          key = @application.file.key.sub(/\.\w+$/, '') # remove extension
          version = "v1761044962" # optional if you want to force a specific version

          cloud_name = Cloudinary.config.cloud_name
          preview_url = "https://res.cloudinary.com/#{cloud_name}/image/upload/#{version}/development/#{key}.png"

          preview_file = URI.open(preview_url)
          pdf.image preview_file, width: 450, position: :center
        rescue => e
          pdf.text "Impossible de charger l'aperçu du formulaire : #{e.message}", size: 9, style: :italic, color: "ff0000"
        end
      else
        pdf.text "Formulaire non fournie", size: 10, style: :italic
      end
    else
      ### PAGE 2 — ID CARD
      if @application.id_card.attached?
        pdf.start_new_page
        pdf.text "Carte d'identité", size: 14, style: :bold
        pdf.move_down 30
        begin
          # Use Cloudinary's preview feature to convert first page of PDF to image
          # Use ActiveStorage key to build the Cloudinary image URL
          key = @application.id_card.key.sub(/\.\w+$/, '') # remove extension
          version = "v1761044962" # optional if you want to force a specific version

          cloud_name = Cloudinary.config.cloud_name
          preview_url = "https://res.cloudinary.com/#{cloud_name}/image/upload/#{version}/production/#{key}.png"

          preview_image = URI.open(preview_url)
          pdf.image preview_image, width: 450, position: :center
        rescue => e
          pdf.text "Impossible de charger l'aperçu de la carte : #{e.message}", size: 9, style: :italic, color: "ff0000"
        end
      else
        pdf.text "Carte d'identité non fournie", size: 10, style: :italic
      end

      ### PAGE 3 — OTHER FILE
      if @application.file.attached?
        pdf.start_new_page
        pdf.text "Formulaire d'Autorisation", size: 14, style: :bold
        pdf.move_down 30
        begin
          # Use Cloudinary's preview feature to convert first page of PDF to image
          # Use ActiveStorage key to build the Cloudinary image URL
          key = @application.file.key.sub(/\.\w+$/, '') # remove extension
          version = "v1761044962" # optional if you want to force a specific version

          cloud_name = Cloudinary.config.cloud_name
          preview_url = "https://res.cloudinary.com/#{cloud_name}/image/upload/#{version}/production/#{key}.png"

          preview_file = URI.open(preview_url)
          pdf.image preview_file, width: 450, position: :center
        rescue => e
          pdf.text "Impossible de charger l'aperçu du formulaire : #{e.message}", size: 9, style: :italic, color: "ff0000"
        end
      else
        pdf.text "Formulaire non fournie", size: 10, style: :italic
      end
    end

    ### SEND PDF
    send_data pdf.render,
              filename: "fiche_candidat_#{@application.first_name.parameterize}.pdf",
              type: "application/pdf",
              disposition: "inline"
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

    # Filter by date
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
      redirect_to confirmation_form_path, notice: notice_message
      SubscriptionMailer.notify_admin(@individual_form, "Solo").deliver_later
    else
      Rails.logger.debug @individual_form.errors.full_messages
      flash[:alert] = I18n.t('individual_form.create.error')
      render :new, status: :unprocessable_entity
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
      # photo: @solo.photo.key,
      file: @solo.file,
      id_card: @solo.id_card,
      solos_list: @results
    }

    rescue ActiveRecord::RecordNotFound
      render json: { error: "Solo not found" }, status: :not_found
  end

  private

  def prevent_new_submissions
    flash[:alert] = "Les inscriptions sont maintenant fermées."
    redirect_to root_path
  end

  def individual_form_params
    params.require(:individual_form).permit(
      :first_name, :last_name, :birth_date, :address,
      :phone, :email, :teacher_name, :dance_school, :teacher_phone,
      :teacher_email, :category, :style, :level,
      :file, :id_card)
      # :photo, :file, :id_card)
  end
end
