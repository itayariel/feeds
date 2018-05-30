class CreateFeeds < ActiveRecord::Migration[5.2]
  def change
    create_table :feeds do |t|
      t.string :title
      t.string :link

      t.timestamps
    end
    add_index :feeds, :title
  end
end
