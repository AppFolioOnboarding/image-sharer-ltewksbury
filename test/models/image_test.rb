require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  def setup
    @testing_tag = '#testing'
  end

  def test_http_url_valid
    @image = create_image('http://image.jpg', @testing_tag)
    assert @image.save
    assert_not @image.errors.any?
  end

  def test_https_url_valid
    @image = create_image('https://image.jpg', @testing_tag)
    assert @image.save
    assert_not @image.errors.any?
  end

  def test_url_invalid
    @image = create_image('htp://image.jpg', @testing_tag)
    assert_not @image.save
    assert @image.errors.any?
  end

  def test_extension_invalid
    @image = create_image('http://image.jp', @testing_tag)
    assert_not @image.save
    assert @image.errors.any?
  end

  def test_extensions_valid
    Image::SUPPORTED_IMAGE_EXTENSIONS.each do |ext|
      @image = create_image('http://image' + ext, @testing_tag)
      assert @image.save
      assert_not @image.errors.any?
    end
  end
end
