class MessagesController < ApplicationController
  def index
    @messages = Message.all.order(created_at: :desc)
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    logger.debug "Message params: #{message_params.inspect}" # Add this line to debug
    if @message.save
      redirect_to contact_path, notice: "Your message has been sent successfully."
    else
      render :new
    end
  end

  private

  def message_params
    params.permit(:name, :email, :message)
  end
end
