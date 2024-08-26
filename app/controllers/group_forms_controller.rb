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
    logger.debug "Received parameters: #{params.inspect}"
    if @group_form.save
      redirect_to root_path, notice: 'Group form was successfully created.'
    else
      render :new
    end
  end

  def info
    @group_form = current_user.group_forms.find(params[:id])
    render json: {
      id: group.id,
      name: group.name,
      responsable: group.responsable,
      address: group.address,
      phone: group.phone,
      email: group.email,
      discipline: group.discipline,
      level: group.level,
      title_of_music: group.title_of_music,
      composer: group.composer,
      length_of_piece: group.length_of_piece,
      participants: group.participants.map { |participant| { id: participant.id, name: participant.name, last_name: participant.last_name, birth_date: participant.birth_date, age: participant.age } }
    }
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Group not found" }, status: :not_found
  end

  private

  def group_form_params
    params.require(:group_form).permit(:name, :responsable, :address, :phone, :email, :discipline, :level, :title_of_music, :composer, :length_of_piece, participants_attributes: [:name, :last_name, :birth_date, :age])
  end
end
