class ImagesController < ApplicationController
  def index
    @images = params[:tag].present? ? Image.tagged_with(tag_params) : Image.all
  end

  def show
    @image = Image.find(id_params)
  end

  def new
    # Needed so that bootstrap_form_for(@image) works
    @image = Image.new
  end

  def create
    @image = Image.new(image_params)
    if @image.save
      redirect_to @image
    else
      # error - prompt user to reenter url
      render 'new'
    end
  end

  def destroy
    Image.find(id_params).destroy
    redirect_to images_path
  end

  private

  def id_params
    params.require(:id)
  end

  def image_params
    params.require(:image).permit(:image_url, :tag_list)
  end

  def tag_params
    params.require(:tag)
  end
end
