require 'test_helper'

class ImageTagParserTest < ActiveSupport::TestCase
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
