require 'rss'
require 'open-uri'

class PullFeedJob < ApplicationJob
  queue_as :default
  retry_on Exception, queue: :low_priority, attempts: 0

  def perform(id)
    feed = Feed.find(id)
    return false if feed.nil?
    open(feed.link) do |rss|
      return false if rss.nil?
      feed_data = RSS::Parser.parse(rss)
      feed_data.items.each do |item|
        begin
          puts(item)
          puts("=================item=========")
          @post  = feed.posts.build({}.merge(:title => item.title,
                                            :description => item.description,
                                            :link => item.enclosure.url,
                                            :html => item.content_encoded))
          if @post.save
            puts('successfully saved!! ')
          else
            puts @post.errors
          end
        rescue Exception => bang
          puts(bang)
        end
    end
  end
end
