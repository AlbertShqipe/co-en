class TriosController < ApplicationController
  before_action :authenticate_user!
  def index
    @trios = current_user.trios
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
      redirect_to apply_path, notice: 'Trio was successfully created.'
    else
      render :new
    end
  end

  def info
    @trio = current_user.trios.find(params[:id])
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
      participants: @trio.trio_participants.map { |participant| { id: participant.id,
                                                                    name: participant.name,
                                                                    last_name: participant.last_name,
                                                                    birth_date: participant.birth_date,
                                                                    age: participant.age,
                                                                    photo: participant.photo.key,
                                                                    file: participant.files }
                                                                  }
    }
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Trio not found" }, status: :not_found
  end

  private

  def trio_params
    params.require(:trio).permit(
      :name, :responsable, :address, :phone, :email, :discipline, :level, :title_of_music, :composer, :length_of_piece,
      trio_participants_attributes: [:name, :last_name, :birth_date, :age, :photo, :files]
    )
  end
end
