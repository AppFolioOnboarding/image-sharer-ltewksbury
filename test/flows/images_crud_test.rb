require 'flow_test_helper'

class ImagesCrudTest < FlowTestCase
  test 'add an image' do
    images_index_page = PageObjects::Images::IndexPage.visit

    new_image_page = images_index_page.add_new_image!

    image_tags = %w[foo bar]
    new_image_page = new_image_page.create_image!(
      url: 'invalid',
      tags: image_tags.join(' ')
    ).as_a(PageObjects::Images::NewPage)
    assert_match 'Image url is not valid.', new_image_page.error_message

    image_tags = '#wombat'
    image_url = 'https://www.factzoo.com/sites/all/img/montage/large-light-wombat.jpg'

    image_show_page = new_image_page.create_image!(
      url: image_url,
      tags: image_tags
    ).as_a(PageObjects::Images::ShowPage)
    assert_equal 'You have successfully added an image.', image_show_page.flash_message_success

    assert_equal image_url, image_show_page.image_url
    assert_equal image_tags, image_show_page.tags

    images_index_page = image_show_page.go_back_to_index!
    assert images_index_page.showing_image?(url: image_url, tags: image_tags)
  end

  test 'delete an image' do
    images_index_page = PageObjects::Images::IndexPage.visit
    initial_count = images_index_page.images.count

    cute_puppy_url = 'http://ghk.h-cdn.co/assets/16/09/980x490/landscape-1457107485-gettyimages-512366437.jpg'
    mean_cat_url = 'http://pixdaus.com/files/items/pics/9/66/246966_166450f821c56904e1d0e84947fd65a2_large.jpg'
    Image.create!([
      { image_url: cute_puppy_url, tag_list: '#puppy #cute' },
      { image_url: mean_cat_url, tag_list: '#cat #mean' }
    ])

    images_index_page = PageObjects::Images::IndexPage.visit
    assert_equal 2, images_index_page.images.count - initial_count
    assert images_index_page.showing_image?(url: mean_cat_url)
    assert images_index_page.showing_image?(url: cute_puppy_url)

    image_to_delete = images_index_page.images.find do |image|
      image.url == mean_cat_url
    end
    image_show_page = image_to_delete.view!

    image_show_page.delete do |confirm_dialog|
      assert_equal 'Are you sure?', confirm_dialog.text
      confirm_dialog.dismiss
    end

    images_index_page = image_show_page.delete_and_confirm!
    assert_equal 'You have successfully deleted the image.', images_index_page.flash_message_success

    assert_equal 1, images_index_page.images.count - initial_count
    assert_not images_index_page.showing_image?(url: mean_cat_url)
    assert images_index_page.showing_image?(url: cute_puppy_url)
  end

  test 'view images associated with a tag' do
    # Account for images pre-loaded by image.yml
    images_index_page = PageObjects::Images::IndexPage.visit
    initial_count = images_index_page.images.count

    puppy_url1 = 'http://www.pawderosa.com/images/puppies.jpg'
    puppy_url2 = 'http://ghk.h-cdn.co/assets/16/09/980x490/landscape-1457107485-gettyimages-512366437.jpg'
    mean_cat_url = 'http://pixdaus.com/files/items/pics/9/66/246966_166450f821c56904e1d0e84947fd65a2_large.jpg'
    Image.create!([
      { image_url: puppy_url1, tag_list: '#superman #cute' },
      { image_url: puppy_url2, tag_list: '#cute #puppy' },
      { image_url: mean_cat_url, tag_list: '#cat #mean' }
    ])

    images_index_page = PageObjects::Images::IndexPage.visit
    [puppy_url1, puppy_url2, mean_cat_url].each do |url|
      assert images_index_page.showing_image?(url: url)
    end

    images_index_page = images_index_page.images[1].click_tag!('#cute')

    assert_equal 2, images_index_page.images.count
    assert_not images_index_page.showing_image?(url: mean_cat_url)

    images_index_page = images_index_page.clear_search!
    assert_equal 3, images_index_page.images.count - initial_count
  end

  test 'use search field to view images associated with a tag' do
    # Account for images pre-loaded by image.yml
    images_index_page = PageObjects::Images::IndexPage.visit
    initial_count = images_index_page.images.count

    puppy_url1 = 'http://www.pawderosa.com/images/puppies.jpg'
    puppy_url2 = 'http://ghk.h-cdn.co/assets/16/09/980x490/landscape-1457107485-gettyimages-512366437.jpg'
    mean_cat_url = 'http://pixdaus.com/files/items/pics/9/66/246966_166450f821c56904e1d0e84947fd65a2_large.jpg'
    Image.create!([
      { image_url: puppy_url1, tag_list: '#superman #cute' },
      { image_url: puppy_url2, tag_list: '#cute #puppy' },
      { image_url: mean_cat_url, tag_list: '#cat #mean' }
    ])

    images_index_page = PageObjects::Images::IndexPage.visit
    [puppy_url1, puppy_url2, mean_cat_url].each do |url|
      assert images_index_page.showing_image?(url: url)
    end

    images_index_page = images_index_page.search!('#cute')
    assert_equal 2, images_index_page.images.count
    assert_not images_index_page.showing_image?(url: mean_cat_url)

    # search for tag that isn't there
    images_index_page = images_index_page.search!('#notthere')
    assert_not images_index_page.showing_no_images?

    images_index_page = images_index_page.clear_search!
    assert_equal 3, images_index_page.images.count - initial_count
  end
end
