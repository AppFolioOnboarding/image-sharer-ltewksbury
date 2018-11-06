module ImagesHelper
  class TagParser < ActsAsTaggableOn::GenericParser
    def parse
      ActsAsTaggableOn::TagList.new.tap do |tag_list|
        tag_list.add @tag_list.split(' ')
        tag_list.each do |tag|
          tag.prepend('#') unless tag.starts_with? '#' # make it a hash tag if it isn't already
        end
      end
    end
  end
end
