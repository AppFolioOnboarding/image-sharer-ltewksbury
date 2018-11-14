module PageObjects
  module Images
    class ShowPage < PageObjects::Document
      path :image

      def image_url
        node.find('img')[:src]
      end

      def tags
        node.find('#tags').text
      end

      def flash_message_success
        node.find('#notice').text
      end

      def delete
        node.click_on('Delete Image')
        yield node.driver.browser.switch_to.alert
      end

      def delete_and_confirm!
        delete(&:accept)
        window.change_to(IndexPage)
      end

      def go_back_to_index!
        node.click_on('Show All')
        window.change_to(IndexPage)
      end
    end
  end
end
