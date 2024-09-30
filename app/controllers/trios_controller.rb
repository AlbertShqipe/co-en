class TriosController < ApplicationController
  before_action :authenticate_user!
  def index
    @trios = Trio.all
    @trio = current_user.trios.find(params[:id]) if params[:id].present?
    @results = Cloudinary::Api.resources(type: "upload", prefix: "development", max_results: 500)['resources']
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
    @trio = Trio.find(params[:id])
    total_age = @trio.trio_participants.sum { |participant| participant.age }
    participant_count = @trio.trio_participants.size
    average_age = participant_count > 0 ? total_age.to_f / participant_count : 0
    average_age.round(2)
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
      participants: @trio.trio_participants.map { |participant| { id: participant.id,
                                                                    name: participant.name,
                                                                    last_name: participant.last_name,
                                                                    birth_date: participant.birth_date,
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
