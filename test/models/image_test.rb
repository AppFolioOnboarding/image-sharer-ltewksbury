require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  def setup
    @testing_tag = '#testing'
  end

  def test_everything_missing_invalid
    @image = new_image('', '')
    assert_not @image.valid?
    assert_equal @image.errors[:image_url].first, 'Please provide an image url.'
    assert_equal @image.errors[:tag_list].first, 'Please provide an image tag.'
  end

  def test_url_missing_invalid
    @image = new_image('', @testing_tag)
    assert_not @image.valid?
    assert_equal @image.errors[:image_url].first, 'Please provide an image url.'
  end

  def test_http_url_valid
    @image = new_image('http://image.jpg', @testing_tag)
    assert @image.valid?
    assert_not @image.errors.any?
  end

  def test_https_url_valid
    @image = new_image('https://image.jpg', @testing_tag)
    assert @image.valid?
    assert_not @image.errors.any?
  end

  def test_url_invalid
    @image = new_image('htp://image.jpg', @testing_tag)
    assert_not @image.valid?
    assert_equal @image.errors[:image_url].first, 'Image url is not valid.'
  end

  def test_extension_invalid
    @image = new_image('http://image.jp', @testing_tag)
    assert_not @image.valid?
    assert_equal @image.errors[:image_url].first, 'Image extension is unsupported / invalid.'
  end

  def test_extensions_valid
    Image::SUPPORTED_IMAGE_EXTENSIONS.each do |ext|
      @image = new_image('http://image' + ext, @testing_tag)
      assert @image.valid?
      assert_not @image.errors.any?
    end
  end

  def test_missing_tags
    @image = new_image('http://image.jpg', '')
    assert_not @image.valid?
    assert_equal @image.errors[:tag_list].first, 'Please provide an image tag.'
  end

  def test_tags_present
    @image = new_image('http://image.jpg', @testing_tag)
    assert @image.valid?
    assert_equal(@image.tag_list.size, 1)
  end
end
