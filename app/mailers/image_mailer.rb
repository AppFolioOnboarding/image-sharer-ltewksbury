class ImageMailer < ApplicationMailer
  default from: 'lauren.tewksbury@appfolio.com'

  def welcome_email
    @image = params[:image] #lt - makes no sense for these fields to be part of the image class
    @url  = 'https://aqueous-waters-47116.herokuapp.com/'
    mail(to: 'lauren.tewksbury@appfolio.com', subject: 'This is a test')
  end

end
