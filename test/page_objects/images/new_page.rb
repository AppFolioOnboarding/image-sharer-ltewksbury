module PageObjects
  module Images
    class NewPage < PageObjects::Document
      path :new_image
      path :images # @todo tewks - this doesn't seem right

      form_for :image do
        element :image_url, locator: '#image_url'
        collection :image_tags, locator: '#image_tags'
      end

      def error_message
        node.find('div.invalid-feedback').text
      end

      def create_image!(url: nil, tags: nil)
        image_url.set url
        image_tags.set tags
        node.click_on('Upload Image')
        window.change_to(NewPage, ShowPage, IndexPage)
      end
    end
  end
end
