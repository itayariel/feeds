require 'rss'
require 'open-uri'

class PullFeedJob < ApplicationJob
  queue_as :default

  def perform(id)
    puts("in pull feed job got id #{id}")
    feed = Feed.find(id)
    return false if feed.nil?
    open(feed.link) do |rss|
      return false if rss.nil?
      feed_data = RSS::Parser.parse(rss)
      puts "Title: #{feed_data.channel.title}"
      feed_data.items.each do |item|
        post = Post.new
        post.save_from_feed(item.title)

        #puts "Item title: #{item.title}"
        #puts item
        #puts "Item description: #{item.description}"
        #puts "Item mp3 url: #{item.enclosure.url}"
        #puts "html before is"
        #puts item.content_encoded
        #puts ''
      end
    end

    # Do something later
  end
end
