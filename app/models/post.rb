class Post < ApplicationRecord
  belongs_to :feed

  def save_from_job(post_params)
    puts("in save from job!!! #{title}")
    puts(post_params)
    @post = Post.new(post_params)
    if @post.save
      puts('successfully saved!! ')
    else
      puts @post.errors
    end
  end



  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:post).permit(:title, :description, :link, :img_link, :html, :feed_id)
  end
end
