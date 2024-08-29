class IndividualFormsController < ApplicationController
  require 'cloudinary'
  before_action :authenticate_user!

  def index
    @individual_forms = IndividualForm.all
    @current_user = current_user
    # @results = Cloudinary::Api.resources(prefix: 'development', type: 'upload', max_results: 10)

    #   # Code that runs only in development
    #   @results = Cloudinary::Api.resources(type: "upload", prefix: "development", max_results: 500)['resources']

      # Code that shoul run only in production
      @results = Cloudinary::Api.resources(type: "upload", prefix: "production", max_results: 500)['resources']
    raise
  end

  def new
    @individual_form = IndividualForm.new
  end

  def create
    # year = params.dig(:individual_form, 'birth_date(1i)')
    # month = params.dig(:individual_form, 'birth_date(2i)')
    # day = params.dig(:individual_form, 'birth_date(3i)')

    # birth_date = Date.new(year.to_i, month.to_i, day.to_i) if year && month && day

    @individual_form = current_user.individual_forms.new(individual_form_params)

    if @individual_form.save
      redirect_to root_path, notice: 'Individual Form successfully created.'
    else
      render :new
    end
  end

  def individual_form_params
    params.require(:individual_form).permit(:first_name, :last_name, :birth_date, :address, :phone, :email, :teacher_name, :dance_school, :teacher_phone, :teacher_email, :category, :style, :level, :photo, :file)
  end
end
