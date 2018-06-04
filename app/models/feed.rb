class Feed < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :feed_members, dependent: :destroy
end
