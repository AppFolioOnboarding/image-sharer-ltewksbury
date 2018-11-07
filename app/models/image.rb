require 'uri'

class Image < ApplicationRecord
  acts_as_taggable
  ActsAsTaggableOn.default_parser = ImagesStuff::ImageTagParser

  SUPPORTED_IMAGE_EXTENSIONS = ['.jpg', '.jpeg', '.png'].freeze

  attr_accessor :email_msg, :email_recipient

  validates :image_url, presence: { message: 'Please provide an image url.' }

  validate do
    if image_url.present?
      errors.add(:image_url, 'Image url is not valid.') unless url_valid?
      errors.add(:image_url, 'Image extension is unsupported / invalid.') unless extension_valid?
    end
    @email_msg = 'from within validate'
  end

  def url_valid?
    url = URI.parse(image_url)
    url.is_a?(URI::HTTP) || url.is_a?(URI::HTTPS)
  end

  def extension_valid?
    SUPPORTED_IMAGE_EXTENSIONS.any? { |ext| image_url.ends_with?(ext) }
  end
end
