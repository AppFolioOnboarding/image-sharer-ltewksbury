ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'

module ActiveSupport
  class TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def new_image(url, tag)
      @image = tag.nil? ? Image.new('image_url' => url) : Image.new('image_url' => url, 'tag_list' => tag)
    end
  end
end
