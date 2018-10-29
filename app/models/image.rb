require 'uri'

class Image < ApplicationRecord
  validate

  SUPPORTED_IMAGE_EXTENSIONS = ['.jpg', '.jpeg', '.png'].freeze

  validates_presence_of :image_url, message: "Please provide an image url."

  validate do
    if image_url.present?
      errors.add(:image_url, "Image url is not valid.") unless url_valid?
      errors.add(:image_url, "Image extension is unsupported / invalid.") unless extension_valid?
    end
  end

  def url_valid?
    url = URI.parse(image_url)
    return true if url.is_a?(URI::HTTP) || url.is_a?(URI::HTTPS)
    false
  end

  def extension_valid?
    return true if SUPPORTED_IMAGE_EXTENSIONS.any? { |ext| image_url.ends_with?(ext) }
    false
  end
end
