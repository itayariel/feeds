require 'rss'
require 'open-uri'

class PullFeedJob < ApplicationJob
  queue_as :default
  retry_on Exception, queue: :low_priority, attempts: 0

  def perform(id)
    puts("in pull feed job got id #{id}")
    feed = Feed.find(id)
    return false if feed.nil?
    open(feed.link) do |rss|
      return false if rss.nil?
      feed_data = RSS::Parser.parse(rss)
      puts "Title: #{feed_data.channel.title}"
      feed_data.items.each do |item|
        #binding.pry
        puts(item)
        puts("=================item=========")
        puts(item.enclosure)
        puts(item.enclosure.url)
        puts(item.enclosure.url.class)
        @post  = feed.posts.build({}.merge(:title => item.title,
                                          :description => item.description,
                                          :link => item.enclosure.url,
                                          :html => item.content_encoded))
        if @post.save
          puts('successfully saved!! ')
        else
          puts @post.errors
        end
        puts(@post)

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
