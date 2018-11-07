require 'test_helper'

class ImageMailerTest < ActionMailer::TestCase
  def test_share_photo_email
    # Create the email and store it for further assertions
    @image = Image.new('image_url' => 'https://www.factzoo.com/sites/all/img/montage/large-light-wombat.jpg')
    email_msg = 'custom text'
    email_recipient = 'lauren.tewksbury@notarealemailaddress.web'

    email = ImageMailer.image_email(@image, email_recipient, email_msg)

    # Send the email, then test that it got queued
    assert_emails 1 do
      email.deliver
    end

    # Test the body of the sent email contains what we expect it to
    assert_equal ['from@example.com'], email.from
    assert_equal [email_recipient], email.to
    assert_equal 'check it out', email.subject
    assert email.text_part.body.include?(email_msg)
    assert email.html_part.body.include?(email_msg)
    assert email.text_part.body.include?('amazing photos')
    assert email.html_part.body.include?('amazing photos')
  end
end
