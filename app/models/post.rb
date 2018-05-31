class Post < ApplicationRecord
  belongs_to :feed

  def save_from_feed(title)
    puts("in save from feed!!! #{title}")
  end
end
