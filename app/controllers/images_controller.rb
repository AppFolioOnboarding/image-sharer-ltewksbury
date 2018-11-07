class ImagesController < ApplicationController
  before_action :fetch_image_from_id, only: %i[show share shared]

  def index
    @images = Image.all
  end

  def show; end

  def new; end

  def create
    @image = Image.new(image_params)
    if @image.save
      redirect_to @image
    else
      render 'new'
    end
  end

  def share; end

  def shared
    respond_to do |format|
      format.html do
        format_email
      end
    end
  end

  private

  def format_email
    ImageMailer.image_email(@image, params[:image][:email_recipient], params[:image][:email_msg]).deliver
    flash[:success] = 'Email successfully sent!'
    redirect_to action: 'index'
  rescue Net::SMTPAuthenticationError, Net::SMTPSyntaxError, Net::SMTPUnknownError => e
    flash[:success] = 'Unable to deliver email!' + e.message
  end

  def image_params
    params.require(:image).permit(:image_url, :tag_list)
  end

  def fetch_image_from_id
    @image = Image.find(params[:id])
  end
end
