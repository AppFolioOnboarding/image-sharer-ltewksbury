require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  test 'http url valid' do
    @image = Image.new('image_url' => 'http://image.jpg')
    assert @image.save
    assert_not @image.errors.any?
  end

  test 'https url valid' do
    @image = Image.new('image_url' => 'https://image.jpg')
    assert @image.save
    assert_not @image.errors.any?
  end

  test 'url invalid' do
    @image = Image.new('image_url' => 'htp://image.jpg')
    assert_not @image.save
    assert @image.errors.any?
  end

  test 'extension invalid' do
    @image = Image.new('image_url' => 'http://image.jp')
    assert_not @image.save
    assert @image.errors.any?
  end

  test 'extensions valid' do
    [Image::JPG, Image::JPEG, Image::PNG].each do |ext|
      @image = Image.new('image_url' => 'http://image'+ ext)
      assert @image.save
      assert_not @image.errors.any?
    end
  end
end
