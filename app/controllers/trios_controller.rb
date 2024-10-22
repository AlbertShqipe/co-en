class TriosController < ApplicationController
  before_action :authenticate_user!
  def index
    @trios = Trio.order(created_at: :asc)
    @trio = current_user.trios.find(params[:id]) if params[:id].present?
    @results_dev = Cloudinary::Api.resources(type: "upload", prefix: "development", max_results: 500)['resources']
    @results_prod = Cloudinary::Api.resources(type: "upload", prefix: "production", max_results: 500)['resources']

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

  def show
    @trio = current_user.trios.find(params[:id])
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
      redirect_to apply_path, notice: notice_message
    else
      render :new
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
                                                                    photo: participant.photo.key,
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
        :name, :last_name, :birth_date, :age, :photo, :file, :id_card
      ]
    )
  end
end
