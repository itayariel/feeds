class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :description
      t.string :link
      t.string :img_link
      t.string :html

      t.belongs_to :feed, index: true
      t.timestamps
    end
  end
end
