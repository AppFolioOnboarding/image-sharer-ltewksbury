require 'test_helper'

class ImageTagParserTest < ActiveSupport::TestCase
  setup do
    @good_url = 'https://photos.smugmug.com/France-and-a-little-bit-of-Spain-Fall-2017/i-pQBT87s/0/07e81c1c/X2/DSC05663-X2.jpg'
  end

  def test_tags_required
    @image = create_image(@good_url)
    assert_not @image.save
    @image = create_image(@good_url, '#testing')
    assert @image.save
    assert_equal(@image.tag_list.size, 1)
  end

  def test_tags_prepended_with_hash
    @image = create_image(@good_url, '#testing')
    assert @image.save
    assert_equal(@image.tag_list.size, 1)
    assert_equal(@image.tag_list.first, '#testing')
  end

  def test_tags_with_hash_not_preprepended_with_hash
    @image = create_image(@good_url, 'testing')
    assert @image.save
    assert_equal(@image.tag_list.size, 1)
    assert_equal(@image.tag_list.first, '#testing')
  end

  def test_tags_delimited_by_space
    @image = create_image(@good_url, '#testing onetwothree')
    assert_equal(@image.tag_list.size, 2)
    assert_equal(@image.tag_list[0], '#testing')
    assert_equal(@image.tag_list[1], '#onetwothree')
  end

  def test_tags_not_delimited_by_comma
    @image = create_image(@good_url, '#testing,onetwothree')
    assert_equal(@image.tag_list.size, 1)
    assert_equal(@image.tag_list[0], '#testing,onetwothree')
  end
end
