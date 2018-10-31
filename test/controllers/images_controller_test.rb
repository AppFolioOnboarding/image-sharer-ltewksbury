require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @good_url = 'http://pumpkin.jpg'
    @bad_url = 'http//pumpkin.jpg'
    @image = Image.create(image_url: @good_url)
  end

  def test_index
    get root_url
    assert_response :ok
  end

  def test_show
    get image_path(@image.id)

    assert_response :ok
    assert_select '#header', 'Image'
  end

  def test_new
    get new_image_path

    assert_response :ok
    assert_select '#header', 'Add a New Image'
  end

  def test_create__succeed
    assert_difference('Image.count', 1) do
      image_params = { image_url: @good_url }
      post images_path, params: { image: image_params }
    end

    assert_redirected_to image_path(Image.last)
  end

  def test_create__fail
    assert_no_difference('Image.count') do
      image_params = { image_url: @bad_url }
      post images_path, params: { image: image_params }
    end

    assert_response :ok
  end
end
