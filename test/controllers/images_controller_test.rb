require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @good_url = 'https://photos.smugmug.com/France-and-a-little-bit-of-Spain-Fall-2017/i-pQBT87s/0/07e81c1c/X2/DSC05663-X2.jpg'
    @bad_url = 'https://photos.smugmug.com/France-and-a-little-bit-of-Spain-Fall-2017/i-pQBT87s/0/07e81c1c/X2/DSC05663-X2.jp'
    @image = Image.new(image_url: @good_url)
    @image.tag_list.add('#testing')
    @image.save!
  end

  def test_index
    get root_url

    assert_response :ok
    # ??
  end

  def test_index_with_tag
    get images_path(tag: '#testing')

    assert_response :ok
    assert_select '#header', 'Stored Images'
    assert_select '#tags', '#testing'
  end

  def test_index_with_not_there_tag
    get images_path(tag: '#thisshouldfail')

    assert_response :ok
    assert_select '#header', 'Stored Images'
    assert_select '#emptySearch', 'No images to display.'
  end

  def test_show
    get image_path(Image.first)

    assert_response :ok
    # ??
  end

  def test_new
    get new_image_path

    assert_response :ok
    # ??
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
