class TriosController < ApplicationController
  before_action :authenticate_user!

  def show
    if current_user.admin?
      @trio = Trio.find(params[:id]) # Admins can access any duo
    else
      @trio = current_user.trios.find(params[:id]) # Competitors can access only their own duos
    end


    @results = []
    Trio.order(created_at: :asc).all.each_with_index do |duo, index|
      @results << {
        count: index + 1,
        id: duo.id,
      }
    end

    # Code that charges the assets uploaded in development
    @results_dev = Cloudinary::Api.resources(type: "upload", prefix: "development", max_results: 500)['resources']

    # Code that charges the assets uploaded in production
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
    @application = Trio.find(params[:id])
    pdf = Prawn::Document.new

    # Logo header
    banner_height = 100
    logo_path = Rails.root.join("app/assets/images/LogoFullOrange1.png")
    if File.exist?(logo_path)
      y_position = pdf.cursor - (banner_height / 2) + 40
      pdf.image logo_path, width: 200, position: :left, at: [pdf.bounds.width / 2 - 100, y_position]
    end

    pdf.fill_color "000000"
    pdf.move_down banner_height + 10
    pdf.text "Fiche Trio", size: 16, style: :bold, align: :center

    pdf.move_down 20
    pdf.text "Informations générales", size: 12, style: :bold
    pdf.move_down 10

    # ===============================
    # PAGE 1 — Trio + Participants Info
    # ===============================
    data = [
      ["Nom du trio", @application.name],
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

    @application.trio_participants.each_with_index do |participant, index|
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
    @application.trio_participants.each_with_index do |participant, index|
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
              filename: "fiche_trio_#{@application.name.parameterize}.pdf",
              type: "application/pdf",
              disposition: "inline"
  end

  def index
    @trios = Trio.order(created_at: :asc)
    @trio = current_user.trios.find(params[:id]) if params[:id].present?

    # Code that charges the assets uploaded in development
    @results_dev = Cloudinary::Api.resources(type: "upload", prefix: "development", max_results: 500)['resources']

    # Code that charges the assets uploaded in production
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

    @trios_filter = Trio.by_discipline(params[:discipline])
                      .by_level(params[:level])
                      .after_date(params[:start_date]) if params[:start_date].present?

    # Filter by multiple styles
    if params[:discipline].present?
      @trios = @trios.where(discipline: params[:discipline])
    end

    # Filter by multiple levels
    if params[:level].present?
      @trios = @trios.where(level: params[:level])
    end

    # # Filter by date
    if params[:start_date].present?
      @trios = @trios.where("created_at >= ?", params[:start_date])
    end
  end

  def new
    @trio = Trio.new
    @trio.trio_participants.build
    # 3.times { @trio.trio_participants.build }
  end

  def create
    @trio = Trio.new(trio_params)
    @trio.user_id = current_user.id
    if @trio.save
      notice_message = I18n.t('trio_form.create.success')
      redirect_to confirmation_form_path, notice: notice_message
      SubscriptionMailer.notify_admin(@trio, "Trio").deliver_later
    else
      Rails.logger.debug @trio.errors.full_messages
      flash[:alert] = I18n.t('individual_form.create.error')
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @trio = Trio.find(params[:id])
    # Code that charges the assets uploaded in development
    @results_dev = Cloudinary::Api.resources(type: "upload", prefix: "development", max_results: 500)['resources']

    # Code that charges the assets uploaded in production
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
    @trio = Trio.find(params[:id])
    if @trio.update(trio_params)
      notice_message = I18n.t('trio_form.update.success')
      redirect_to trio_path(@trio), notice: notice_message
    else
      render :edit, alert: t('edit.flash_messages.error')
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

    @trio = Trio.find(params[:id])
    total_age = @trio.trio_participants.sum { |participant| participant.age }
    participant_count = @trio.trio_participants.size
    average_age = participant_count > 0 ? total_age.to_f / participant_count : 0
    average_age.round(2)
    @results = []
    Trio.all.each_with_index do |trio, index|
      @results << {
        count: index + 1,
        id: trio.id,
      }
    end
    render json: {
      id: @trio.id,
      name: @trio.name,
      responsable: @trio.responsable,
      address: @trio.address,
      phone: @trio.phone,
      email: @trio.email,
      discipline: @trio.discipline,
      level: @trio.level,
      title_of_music: @trio.title_of_music,
      composer: @trio.composer,
      length_of_piece: @trio.length_of_piece,
      average_age: average_age.round(2),
      trio_lists: @results,
      participants: @trio.trio_participants.map { |participant| { id: participant.id,
                                                                    name: participant.name,
                                                                    last_name: participant.last_name,
                                                                    birth_date:  I18n.l(participant.birth_date, format: :long, locale: :fr), # This will translate the date to French,,
                                                                    age_day_competition: calculate_age(participant.birth_date.strftime("%Y-%m-%d")),
                                                                    age: participant.age,
                                                                    # photo: participant.photo.key,
                                                                    file: participant.file,
                                                                    id_card: participant.id_card}
                                                                  }
    }
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Trio not found" }, status: :not_found
  end

  private

  def trio_params
    params.require(:trio).permit(
      :name, :responsable, :address, :phone, :email,
      :title_of_music, :composer, :length_of_piece,
      :discipline, :level,
      trio_participants_attributes: [
        :id, :name, :last_name, :birth_date, :age,
        :file, :id_card, :_destroy
        # :photo, :file, :id_card, :_destroy
      ]
    )
  end
end
