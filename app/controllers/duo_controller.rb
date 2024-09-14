class DuoController < ApplicationController
  before_action :authenticate_user!
  def index
    @duos = current_user.duos
    @duo = current_user.duos.find(params[:id]) if params[:id].present?
    @results = Cloudinary::Api.resources(type: "upload", prefix: "development", max_results: 500)['resources']
  end

  def show
    @duo = current_user.duos.find(params[:id])
  end

  def new
    @duo = Duo.new
    @duo.duo_participants.build
  end

  def create
    @duo = Duo.new(duo_params)
    @duo.user_id = current_user.id
    if @duo.save
      redirect_to apply_path, notice: 'Duo was successfully created.'
    else
      render :new
    end
  end

  def info
    @duo = Duo.find(params[:id])
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
      participants: @duo.duo_participants.map { |participant| {
                                                  id: participant.id,
                                                  name: participant.name,
                                                  last_name: participant.last_name,
                                                  birth_date: participant.birth_date,
                                                  age: participant.age,
                                                  photo: participant.photo.key,
                                                  file: participant.files
                                                }
                                              }
    }
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Duo not found" }, status: :not_found
  end

  private

  def duo_params
    params.require(:duo).permit(
      :name, :responsable, :address, :phone, :email, :discipline, :level, :title_of_music, :composer, :length_of_piece,
      duo_participants_attributes: [:name, :last_name, :birth_date, :age, :photo, :files]
    )
  end
end
