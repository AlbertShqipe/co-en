class GroupFormsController < ApplicationController
  before_action :authenticate_user!
  def index
    @group_forms = current_user.group_forms
    @group_form = current_user.group_forms.find(params[:id]) if params[:id].present?
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
      redirect_to new_group_form_path, alert: 'At least four participants are required'
    elsif @group_form.save
      redirect_to apply_path, notice: 'Group form was successfully created.'
    else
      render :new, alert: 'There was an issue creating the group form.'
    end
  end



  def info
    @group_form = GroupForm.find(params[:id])
    total_age = @group_form.participants.sum { |participant| participant.age }
    participant_count = @group_form.participants.size
    average_age = participant_count > 0 ? total_age.to_f / participant_count : 0
    average_age.round(2)
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
      participants: @group_form.participants.map { |participant| { id: participant.id,
                                                                    name: participant.name,
                                                                    last_name: participant.last_name,
                                                                    birth_date: participant.birth_date,
                                                                    age: participant.age,
                                                                    photo: participant.photo.key,
                                                                    file: participant.files }
                                                                  }
    }
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Group not found" }, status: :not_found
  end

  private

  def group_form_params
    params.require(:group_form).permit(:name, :responsable, :address, :phone, :email, :discipline, :level, :title_of_music, :composer, :length_of_piece, participants_attributes: [:name, :last_name, :birth_date, :age, :files, :photo])
  end
end
