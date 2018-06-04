class CreateFeedMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :feed_members do |t|

      t.belongs_to :user, index: true
      t.belongs_to :feed, index: true
      t.timestamps
    end
  end
end
