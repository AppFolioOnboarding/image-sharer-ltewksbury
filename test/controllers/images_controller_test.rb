require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @good_url = 'https://www.factzoo.com/sites/all/img/montage/large-light-wombat.jpg'
    @bad_url = 'htt://www.factzoo.com/sites/all/img/montage/large-light-wombat.jpg'
    @image = Image.create(image_url: @good_url)
  end

  def test_index
    get root_url

    assert_response :ok
    assert_select '#header', 'Stored Images'
  end

  def test_share
    get share_image_path(@image.id)
    assert_response :ok
  end

  def test_shared__succeed
    image_params = { image_url: @good_url, email_msg: 'yo', email_recipient: 'lauren.tewksbury@appfolio.com' }
    post share_image_path(@image.id), params: { image: image_params }

    assert_redirected_to images_path
    assert_equal 'Email successfully sent!', flash[:success]
  end

  def test_shared__fail
    # @todo - tewks (how do I trigger this error?)
    # image_params = { image_url: @good_url, email_msg: 'yo', email_recipient: 'yo@notarealemailaddress.web'}
    # post share_image_path(@image.id), params: { image: image_params }
    # assert_response :ok
    # assert_equal 'Unable to deliver email!', flash[:success]
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

  def test_share_image_email_delivered
    email_msg = 'yo'
    email_recipient = 'lauren.tewksbury@appfolio.com'
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      image_params = { image_url: @good_url, email_msg: email_msg, email_recipient: email_recipient }
      post share_image_path(@image.id), params: { image: image_params }
    end
    share_photo_email = ActionMailer::Base.deliveries.last

    assert_equal 'check it out', share_photo_email.subject
    assert_equal email_recipient, share_photo_email.to[0]
    assert share_photo_email.html_part.body.include?(email_msg)
  end
end
