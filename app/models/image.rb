require 'uri'

class Image < ApplicationRecord
  validate :url_valid?,
           :extension_valid?

  JPG = '.jpg'.freeze
  JPEG = '.jpeg'.freeze
  PNG = '.png'.freeze
  SUPPORTED_IMAGE_EXTENSIONS = [JPG, JPEG, PNG].freeze

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

  # checks that user hasn't passed an invalid image extension
  def extension_valid?
    return true if SUPPORTED_IMAGE_EXTENSIONS.any? { |ext| image_url.ends_with?(ext) }
    errors.add(:extension, 'unsupported/invalid')
    false
  end
end
