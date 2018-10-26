require 'uri'

class Image < ApplicationRecord
  validate :url_valid?,
           :extension_valid?

  private

  # checks that start of url is properly formed
  def url_valid?
    validate_url
    errors.blank?
  end

  def validate_url
    url = URI.parse(image_url)
    errors.add(:url, 'invalid') unless url.is_a?(URI::HTTP) || url.is_a?(URI::HTTPS)
  end

  JPG = '.jpg'.freeze
  JPEG = '.jpeg'.freeze
  PNG = '.png'.freeze

  # checks that user hasn't passed an invalid image extension
  def extension_valid?
    return true if image_url.ends_with?(JPG) || image_url.ends_with?(JPEG) || image_url.ends_with?(PNG)
    errors.add(:extension, 'unsupported/invalid')
    false
  end
end
