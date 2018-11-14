module PageObjects
  module Images
    class IndexPage < PageObjects::Document
      path :images

      collection :images, locator: '.album', item_locator: '.card', contains: ImageCard do
        def view!
          node.find('img').click
          window.change_to(ShowPage)
        end
      end

      def add_new_image!
        node.click_on('New Photo')
        window.change_to(NewPage)
      end

      def showing_image?(url:, tags: nil)
        images.find do |image|
          image.url == url && (image.tags == tags || !tags)
        end
      end

      def showing_no_images?
        node.find('#emptySearch').nil?
      end

      def flash_message_success
        node.find('#notice').text
      end

      def search!(search_for)
        node.find('#tag').set(search_for)
        node.click_on('Search')
        window.change_to(IndexPage)
      end

      def clear_search!
        node.find('#tag').set('')
        node.click_on('Search')
        window.change_to(IndexPage)
      end
    end
  end
end
