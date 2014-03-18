class CreateLinks < ActiveRecord::Migration
  def change
    # rake db:migrate
    # drop_table :links
    create_table :links do |t|
      t.string :original_link
      t.string :shortened_link
      t.integer :click_count

      t.timestamps
    end
  end
end
