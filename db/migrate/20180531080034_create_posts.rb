class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.string :link
      t.string :img_link
      
      t.belongs_to :feed, index: true
      t.timestamps
    end
  end
end
