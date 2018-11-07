require 'open-uri'

class ImageMailer < ApplicationMailer
  def image_email(image, email_recipient, email_msg)
    @image = image
    @url = 'https://aqueous-waters-47116.herokuapp.com/'
    @email_msg = email_msg
    attachments.inline['file.jpg'] = URI.parse(@image.image_url).open(&:read)
    mail(to: email_recipient, subject: 'check it out')
  end
end
