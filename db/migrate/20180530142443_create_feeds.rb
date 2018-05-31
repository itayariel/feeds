class CreateFeeds < ActiveRecord::Migration[5.2]
  def change
    create_table :feeds do |t|
      t.string :title
      t.string :link
      t.string :img_link

      t.belongs_to :user, index: true
      t.timestamps
    end
    add_index :feeds, :title
  end
end
