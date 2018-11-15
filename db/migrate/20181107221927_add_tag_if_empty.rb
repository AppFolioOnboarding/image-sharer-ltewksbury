class AddTagIfEmpty < ActiveRecord::Migration[5.2]

  PLACEHOLDER_TAG_NAME = '#placeholder'.freeze
  def up
=begin
    #Search for all untagged images
    @untagged = Array.new
    Image.all.each do |img|
      @untagged.push img if ActsAsTaggableOn::Tagging.find_by(taggable_id: img.id).nil?
    end

    #Associate each image with this placeholder
    @untagged.each do |img|
      new_tagging = ActsAsTaggableOn::Tagging.create!(tag_id: new_tag.id, taggable_type: "Image", taggable_id: img.id, context: "tags")
    end
=end
  #<<~SQL
  #   SELECT count(name) FROM tags WHERE name='#placeholder';
  #SQL


#=begin
  #create the placeholder tag
  execute <<~SQL
    INSERT INTO tags (name) VALUES ('#placeholder');
  SQL

  #get the id of the placeholder tag
  placeholder_id = execute <<~SQL
    SELECT tags.id FROM tags WHERE tags.name='#placeholder';
  SQL

  # associate image with tag in taggings table
  execute <<~SQL
    INSERT INTO taggings(tag_id, taggable_id, taggable_type, context, created_at) SELECT #{placeholder_id[0]['id']}
      AS tag_id, images.id, 'Image', 'tags', '#{Time.now}' FROM images
      LEFT JOIN taggings ON images.id = taggings.taggable_id
      LEFT JOIN tags ON taggings.tag_id = tags.id
      WHERE tags.id is null;
  SQL

  # how many images have the placeholder tag?
  placeholder_count = execute <<~SQL
    SELECT Count(tag_id) FROM taggings WHERE tag_id = #{placeholder_id[0]['id']};
  SQL

  # update the placeholder_count value in tags with that value
  execute <<~SQL
    UPDATE tags SET taggings_count ="#{placeholder_count[0]['Count(tag_id)']}" WHERE name="#placeholder";
  SQL
#=end
=begin

    INSERT INTO taggings(tag_id, taggable_id, taggable_type, context) SELECT
      (SELECT tags.id FROM tags WHERE tags.name="#placeholder")
      AS tag_id, images.id, 'Image', 'tags' FROM images
      LEFT JOIN taggings ON images.id = taggings.taggable_id
      LEFT JOIN tags ON taggings.tag_id = tags.id
      WHERE tags.id is null;

  execute <<~SQL
    INSERT INTO taggings(tag_id, taggable_id, taggable_type, context, created_at) SELECT
      (SELECT tags.id FROM tags WHERE tags.name="#placeholder")
      AS tag_id, images.id, 'Image', 'tags', '2018-11-07 23:38:46.698387' FROM images
      LEFT JOIN taggings ON images.id = taggings.taggable_id
      LEFT JOIN tags ON tags.id = taggings.tag_id
      WHERE tags.name is null;
  SQL
=end

end

  def down
=begin
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
=end
#=begin
  #get the id of the placeholder tag
  placeholder_id = execute <<~SQL
    SELECT tags.id FROM tags WHERE tags.name='#placeholder';
  SQL

  execute <<~SQL
    DELETE from taggings WHERE taggings.tag_id=#{placeholder_id[0]['id']};
  SQL

  execute <<~SQL
    DELETE from tags where name='#placeholder';
  SQL
#=end
end

end
