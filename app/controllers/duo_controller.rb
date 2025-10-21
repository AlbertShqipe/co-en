class DuoController < ApplicationController
  before_action :authenticate_user!

  def show
    if current_user.admin?
      @duo = Duo.find(params[:id]) # Admins can access any duo
    else
      @duo = current_user.duos.find(params[:id]) # Competitors can access only their own duos
    end

    @results = []
    Duo.order(created_at: :asc).all.each_with_index do |duo, index|
      @results << {
        count: index + 1,
        id: duo.id,
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
    @application = Duo.find(params[:id])
    pdf = Prawn::Document.new

    # ===============================
    # PAGE 1 — Duo + Participants Info
    # ===============================
    logo_path = Rails.root.join("app/assets/images/LogoFullOrange1.png")
    if File.exist?(logo_path)
      y_position = pdf.cursor - 50
      pdf.image logo_path, width: 200, position: :left, at: [pdf.bounds.width / 2 - 100, y_position]
    end

    pdf.move_down 110
    pdf.text "Fiche Duo", size: 16, style: :bold, align: :center
    pdf.move_down 20
    pdf.text "Informations générales", size: 12, style: :bold
    pdf.move_down 10

    data = [
      ["Nom du duo", @application.name],
      ["Responsable", @application.responsable],
      ["Adresse", @application.address],
      ["Téléphone", @application.phone],
      ["Email", @application.email],
      ["Style", @application.discipline],
      ["Niveau", @application.level],
      ["Titre de la musique", @application.title_of_music],
      ["Compositeur", @application.composer],
      ["Durée du morceau", @application.length_of_piece]
    ]

    @application.duo_participants.each_with_index do |participant, index|
      data << ["Participant #{index + 1}", "#{participant.name} #{participant.last_name}"]
      data << ["Date de naissance", participant.birth_date.strftime("%d/%m/%Y")]
      data << ["Âge", participant.age]
    end

    pdf.table(data, row_colors: ["F0F0F0", "FFFFFF"], cell_style: { padding: [5, 10], size: 10 }, width: pdf.bounds.width)
    pdf.move_down 30
    pdf.text "Rapport généré le #{Date.today.strftime('%d/%m/%Y')}", align: :right, size: 8

    # ===============================
    # Pages 2–5 — Each participant's docs
    # ===============================
    @application.duo_participants.each_with_index do |participant, index|
      if participant.id_card.attached?
        pdf.start_new_page
        pdf.text "Carte d'identité — Participant #{index + 1}, #{participant.name} #{participant.last_name}" , size: 14, style: :bold
        pdf.move_down 30
        begin
          key = participant.id_card.key.sub(/\.\w+$/, '')
          cloud_name = Cloudinary.config.cloud_name
          env = Rails.env.production? ? "production" : "development"
          preview_url = "https://res.cloudinary.com/#{cloud_name}/image/upload/v1761044962/#{env}/#{key}.png"
          image = URI.open(preview_url)
          pdf.image image, width: 450, position: :center
        rescue => e
          pdf.text "Impossible de charger l'aperçu de la carte : #{e.message}", size: 9, style: :italic, color: "ff0000"
        end
      end

      if participant.file.attached?
        pdf.start_new_page
        pdf.text "Formulaire — Participant #{index + 1}, #{participant.name} #{participant.last_name}", size: 14, style: :bold
        pdf.move_down 30
        begin
          key = participant.file.key.sub(/\.\w+$/, '')
          cloud_name = Cloudinary.config.cloud_name
          env = Rails.env.production? ? "production" : "development"
          preview_url = "https://res.cloudinary.com/#{cloud_name}/image/upload/v1761044962/#{env}/#{key}.png"
          image = URI.open(preview_url)
          pdf.image image, width: 450, position: :center
        rescue => e
          pdf.text "Impossible de charger l'aperçu du formulaire : #{e.message}", size: 9, style: :italic, color: "ff0000"
        end
      end
    end

    # ===============================
    # SEND PDF
    # ===============================
    send_data pdf.render,
              filename: "fiche_duo_#{@application.name.parameterize}.pdf",
              type: "application/pdf",
              disposition: "inline"
  end

  def index
    @duos = Duo.order(created_at: :asc)
    @duo = current_user.duos.find(params[:id]) if params[:id].present?

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

    @results = []
    Duo.order(created_at: :asc).each_with_index do |solo, index|
      @results << {
        count: index + 1,
        id: solo.id,
      }
    end

    @duos_filter = Duo.by_discipline(params[:discipline])
                      .by_level(params[:level])
                      .after_date(params[:start_date]) if params[:start_date].present?

    # Filter by multiple styles
    if params[:discipline].present?
      @duos = @duos.where(discipline: params[:discipline])
    end

    # Filter by multiple levels
    if params[:level].present?
      @duos = @duos.where(level: params[:level])
    end

    # # Filter by date
    if params[:start_date].present?
      @duos = @duos.where("created_at >= ?", params[:start_date])
    end
  end

  def new
    @duo = Duo.new
    @duo.duo_participants.build
  end

  def create
    @duo = Duo.new(duo_params)
    @duo.user_id = current_user.id
    if @duo.save
      notice_message = I18n.t('duo_form.create.success')
      redirect_to confirmation_form_path, notice: notice_message
      SubscriptionMailer.notify_admin(@duo, "Duo").deliver_later
    else
      Rails.logger.debug @duo.errors.full_messages
      flash[:alert] = I18n.t('individual_form.create.error')
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @duo = Duo.includes(:duo_participants).find(params[:id])

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
    @duo = Duo.find_by(id: params[:id])

    if @duo.nil?
      redirect_to duos_path, alert: t('edit.flash_messages.not_found') and return
    end

    if @duo.update(duo_params)
      redirect_to duo_path(@duo), notice: t('edit.flash_messages.success')
    else
      flash.now[:alert] = t('edit.flash_messages.error')
      reload_cloudinary_resources
      render :edit, status: :unprocessable_entity
    end
  end


  def secret
    @duos.each do |duo|
      duo.duo_participants.each_with_index do |participant, index|
        if participant.file.attached?
          key = participant.file.key
          Rails.logger.info "Looking for Cloudinary resource with key: production/#{key}"

          matching_file = @results_prod.find { |hash| hash["public_id"] == "production/#{key}" }

          if matching_file.present?
            newkey = matching_file["asset_id"]
            Rails.logger.info "Updating asset_id for participant #{participant.id} to #{newkey}"

            if participant.update!(asset_id: newkey)
              Rails.logger.info "Successfully updated participant #{participant.id}"
            else
              Rails.logger.error "Failed to update participant #{participant.id}: #{participant.errors.full_messages.join(', ')}"
            end
          else
            Rails.logger.error "No matching Cloudinary resource found for key: production/#{key}"
          end
        else
          Rails.logger.info "Participant #{participant.id} has no attached file"
        end
      end
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

    @results = []
    @results_prod = Cloudinary::Api.resources(type: "upload", prefix: "production", max_results: 500)['resources']
    @duos = Duo.all
    @duo = Duo.find(params[:id])
    Duo.all.each_with_index do |duo, index|
      @results << {
        count: index + 1,
        id: duo.id,
      }
    end
    total_age = @duo.duo_participants.sum { |participant| participant.age }
    participant_count = @duo.duo_participants.size
    average_age = participant_count > 0 ? total_age.to_f / participant_count : 0
    average_age.round(2)
    render json: {
      id: @duo.id,
      name: @duo.name,
      responsable: @duo.responsable,
      address: @duo.address,
      phone: @duo.phone,
      email: @duo.email,
      discipline: @duo.discipline,
      level: @duo.level,
      title_of_music: @duo.title_of_music,
      composer: @duo.composer,
      length_of_piece: @duo.length_of_piece,
      average_age: average_age.round(2),
      duo_lists: @results,
      participants: @duo.duo_participants.map { |participant| {
                                                  id: participant.id,
                                                  name: participant.name,
                                                  last_name: participant.last_name,
                                                  birth_date:  I18n.l(participant.birth_date, format: :long, locale: :fr), # This will translate the date to French,,
                                                  age_day_competition: calculate_age(participant.birth_date.strftime("%Y-%m-%d")),
                                                  age: participant.age,
                                                  # photo: participant.photo.key,
                                                  file: participant.file,
                                                  id_card: participant.id_card,
                                                  asset_id: participant.asset_id
                                                }
                                              }
    }
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Duo not found" }, status: :not_found
  end

  private

  def duo_params
    params.require(:duo).permit(
      :name, :responsable, :address, :phone, :email,
      :title_of_music, :composer, :length_of_piece,
      :discipline, :level,
      duo_participants_attributes: [
        :id, :name, :last_name, :birth_date, :age,
        :file, :id_card
        # :photo, :file, :id_card
      ]
    )
  end
end
