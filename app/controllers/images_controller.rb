class ImagesController < ApplicationController
  def index
    @images = Image.all
  end

  def show
    @image = Image.find(params[:id])

    respond_to do |format|
      if @user.save
        # Tell the UserMailer to send a welcome email after save
        ImageMailer.with(image: @image).image_email.deliver_now

        format.html { redirect_to(@image, notice: 'Image was successfully sent.') }
        format.json { render json: image, status: :created, location: @image }
      else
        format.html { render action: 'new' }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  def new; end

  def create
    @image = Image.new(image_params)
    if @image.save
      redirect_to @image
    else
      # error - prompt user to reenter url
      render 'new'
    end
  end

  def share
    @image = Image.find(params[:id])
  end

  private

  def image_params
    params.require(:image).permit(:image_url, :tag_list)
  end
end
