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
    Image::SUPPORTED_IMAGE_EXTENSIONS.each do |ext|
      @image = Image.new('image_url' => 'http://image' + ext)
      assert @image.save
      assert_not @image.errors.any?
    end
  end

  test 'tags not required' do
    @image = Image.create('image_url' => 'http://image.jpg')
    assert @image.save
    assert_equal(@image.tag_list.size, 0)
  end

  test 'tags prepended with hash' do
    @image = Image.create('image_url' => 'http://image.jpg')
    @image.tag_list = 'testing'
    assert @image.save
    assert_equal(@image.tag_list.size, 1)
    assert_equal(@image.tag_list.first, '#testing')
  end

  test 'tags with hash not reprepended with hash' do
    @image = Image.create('image_url' => 'http://image.jpg')
    @image.tag_list = '#testing'
    assert @image.save
    assert_equal(@image.tag_list.size, 1)
    assert_equal(@image.tag_list.first, '#testing')
  end

  test 'tags delimited by space' do
    @image = Image.create('image_url' => 'http://image.jpg')
    @image.tag_list = '#testing onetwothree'
    assert_equal(@image.tag_list.size, 2)
    assert_equal(@image.tag_list[0], '#testing')
    assert_equal(@image.tag_list[1], '#onetwothree')
  end

  test 'tags not delimited by comma' do
    @image = Image.create('image_url' => 'http://image.jpg')
    @image.tag_list = '#testing,onetwothree'
    assert_equal(@image.tag_list.size, 1)
    assert_equal(@image.tag_list[0], '#testing,onetwothree')
  end
end
