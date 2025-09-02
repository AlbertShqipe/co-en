class ProfessorsController < ApplicationController
  def new
    @professor = Professor.new
  end

  def create
    @professor = Professor.new(professor_params)
    if @professor.save
      redirect_to root_path, notice: "Thanks! You’re subscribed."
      # Or redirect_to some_thank_you_path
    else
      flash.now[:alert] = "Please fix the errors below."
      render :new, status: :unprocessable_entity
    end
  end

  private

  def professor_params
    params.require(:professor).permit(:first_name, :last_name, :school)
  end
end
