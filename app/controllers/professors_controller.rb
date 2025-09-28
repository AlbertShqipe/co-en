class ProfessorsController < ApplicationController

  def show
    if current_user.admin?
      @professor = Professor.find(params[:id]) # Admins can access any professor
    else
      @professor = current_user.professors.find(params[:id]) # Users can access only their own professors
    end
  end

  def index
    @results = []
    @professors = Professor.all.order(created_at: :asc)
    @professors.each_with_index do |solo, index|
      @results << {
        count: index + 1,
        id: solo.id,
      }
    end

    # Filter by date
    if params[:start_date].present?
      @professors = @professors.where("created_at >= ?", params[:start_date]) if params[:start_date].present?
    end
  end

  def new
    @professor = Professor.new
  end

  def create
    @professor = current_user.professors.build(professor_params)
    if @professor.save
      redirect_to confirmation_form_path, notice: "Thanks! You’re subscribed."
      SubscriptionMailer.notify_admin(@professor, "Professor").deliver_later
      # Or redirect_to some_thank_you_path
    else
      flash.now[:alert] = "Please fix the errors below."
      render :new, status: :unprocessable_entity
    end
  end

  def info
    professor = Professor.find(params[:id])

    @results = []
    Professor.all.each_with_index do |prof, index|
      @results << {
        count: index + 1,
        id: prof.id,
      }
    end

    render json: {
      id: professor.id,
      first_name: professor.first_name,
      last_name: professor.last_name,
      school_name: professor.school,
      professor_lists: @results
    }
  end
  private

  def professor_params
    params.require(:professor).permit(:first_name, :last_name, :school)
  end
end
