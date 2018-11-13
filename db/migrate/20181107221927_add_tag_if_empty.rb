class AddTagIfEmpty < ActiveRecord::Migration[5.2]

  PLACEHOLDER_TAG_NAME = '#placeholder'.freeze
  def up

    #Search for all untagged images
    @untagged = Array.new
    Image.all.each do |img|
      @untagged.push img if ActsAsTaggableOn::Tagging.find_by(taggable_id: img.id).nil?
    end

    #Create a new placeholder tag (if it doesn't already exist)
    new_tag = ActsAsTaggableOn::Tag.find_by(name: PLACEHOLDER_TAG_NAME)
    if new_tag.nil?
      new_tag = ActsAsTaggableOn::Tag.create!(name: PLACEHOLDER_TAG_NAME) unless @untagged.empty?
    end

    #Associate each image with this placeholder
    @untagged.each do |img|
      new_tagging = ActsAsTaggableOn::Tagging.create!(tag_id: new_tag.id, taggable_type: "Image", taggable_id: img.id, context: "tags")
    end
end

  def down
    #Which tag am I deleting
    tag_to_delete = ActsAsTaggableOn::Tag.find_by(name: PLACEHOLDER_TAG_NAME)

    #Find all taggings associated with this tag, and delete them
    if not tag_to_delete.nil? then
      taggings_to_delete = ActsAsTaggableOn::Tagging.where(tag_id: tag_to_delete.id)
      taggings_to_delete.each do |tagging|
        ActsAsTaggableOn::Tagging.delete(tagging.id)
      end
    end
  end

end
