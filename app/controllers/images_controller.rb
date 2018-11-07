class ImagesController < ApplicationController
  def index
    @images = params[:tag].present? ? Image.tagged_with(params[:tag]) : Image.all
  end

  def show
    @image = Image.find(params[:id])
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

  private

  def image_params
    params.require(:image).permit(:image_url, :tag_list)
  end
end
