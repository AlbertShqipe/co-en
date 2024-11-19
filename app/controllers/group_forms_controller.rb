class GroupFormsController < ApplicationController
  before_action :authenticate_user!
  def index
    @group_forms = GroupForm.order(created_at: :asc)
    @group_form = current_user.group_forms.find(params[:id]) if params[:id].present?
    @results_dev = Cloudinary::Api.resources(type: "upload", prefix: "development", max_results: 500)['resources']
    @results_prod = Cloudinary::Api.resources(type: "upload", prefix: "Production", max_results: 500)['resources']

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

  def show
    @group_form = current_user.group_forms.find(params[:id])
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
    else
      alert_message1 = I18n.t('group_form.create.error')
      render :new, alert: alert_message1
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
                                                                    photo: participant.photo.key,
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
        :name, :last_name, :birth_date, :age, :photo, :file, :id_card
      ]
    )
  end
end
