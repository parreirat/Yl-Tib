class CreateLinks < ActiveRecord::Migration
  def change

    drop_table :links
    create_table :links do |t|
      t.string :original_link
      t.string :shortened_link
      t.string :author_id
      t.string :link_name
      t.integer :click_count

      t.timestamps
    end
  end
end
