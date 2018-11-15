class AddTagIfEmpty < ActiveRecord::Migration[5.2]

  PLACEHOLDER_TAG_NAME = '#placeholder'.freeze
  def up
#=begin
    #create the placeholder tag (if it isn't already there)
    placeholder_already_there = execute <<~SQL
        SELECT Count(name) from tags where name='#placeholder';
    SQL

    if placeholder_already_there[0]['Count(name)'] == 0 then
      execute <<~SQL
        INSERT INTO tags (name) VALUES ('#placeholder');
      SQL
    end

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
  end

  def down
#=begin
    #get the id of the placeholder tag
    placeholder_id = execute <<~SQL
      SELECT tags.id FROM tags WHERE tags.name='#placeholder';
    SQL

    # Delete any taggings associated with this tag
    execute <<~SQL
      DELETE from taggings WHERE taggings.tag_id=#{placeholder_id[0]['id']};
    SQL

    # Delete the tag itself
    execute <<~SQL
      DELETE from tags where name='#placeholder';
    SQL
#=end
  end

end
