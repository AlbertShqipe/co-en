class DuoController < ApplicationController
  before_action :authenticate_user!
  def index
    @duos = Duo.all
    @duo = current_user.duos.find(params[:id]) if params[:id].present?
    @results_dev = Cloudinary::Api.resources(type: "upload", prefix: "development", max_results: 500)['resources']
    @results_prod = Cloudinary::Api.resources(type: "upload", prefix: "production", max_results: 500)['resources']
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
      notice_message = I18n.t('duo_form.create.success')
      redirect_to apply_path, notice: notice_message
    else
      render :new
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
                                                  birth_date: participant.birth_date,
                                                  age: participant.age,
                                                  photo: participant.photo.key,
                                                  file: participant.file,
                                                  id_card: participant.id_card,
                                                  asset_id: participant.asset_id
                                                }
                                              }
    }
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Duo not found" }, status: :not_found
  end

  # def table
  #   @duo = Duo.find(params[:id])
  #   @results = []
  #   Duo.all.each_with_index do |duo, index|
  #     @results << {
  #       count: index + 1,
  #       id: duo.id,
  #     }
  #   end
  #   total_age = @duo.duo_participants.sum { |participant| participant.age }
  #   participant_count = @duo.duo_participants.size
  #   average_age = participant_count > 0 ? total_age.to_f / participant_count : 0
  #   average_age.round(2)
  #   render json: {
  #     id: @duo.id,
  #     name: @duo.name,
  #     responsable: @duo.responsable,
  #     address: @duo.address,
  #     phone: @duo.phone,
  #     email: @duo.email,
  #     discipline: @duo.discipline,
  #     level: @duo.level,
  #     title_of_music: @duo.title_of_music,
  #     composer: @duo.composer,
  #     length_of_piece: @duo.length_of_piece,
  #     average_age: average_age.round(2),
  #     duo_lists: @results,
  #     participants: @duo.duo_participants.map { |participant| {
  #                                                 id: participant.id,
  #                                                 name: participant.name,
  #                                                 last_name: participant.last_name,
  #                                                 birth_date: participant.birth_date,
  #                                                 age: participant.age,
  #                                                 photo: participant.photo.key,
  #                                                 file: participant.file,
  #                                                 id_card: participant.id_card
  #                                               }
  #                                             }
  #   }
  #   rescue ActiveRecord::RecordNotFound
  #     render json: { error: "Duo not found" }, status: :not_found
  # end

  private

  def duo_params
    params.require(:duo).permit(
      :name, :responsable, :address, :phone, :email,
      :title_of_music, :composer, :length_of_piece,
      :discipline, :level,
      duo_participants_attributes: [
        :name, :last_name, :birth_date, :age, :photo, :file, :id_card
      ]
    )
  end
end
