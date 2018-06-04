require('pry')

class FeedsController < ApplicationController
  before_action :redirect_if_not_signed_in
  before_action :set_feed, only: [:show, :edit, :update, :destroy, :add_member, :remove_member]
  before_action :check_owner, only: [:edit, :update, :destroy, :add_member, :remove_member]

  # GET /feeds
  # GET /feeds.json
  def index
    @feeds = Feed.joins(:feed_members).where(feed_members: { user: current_user })
  end

  # GET /feeds/1
  # GET /feeds/1.json
  def show
    @feed_members = FeedMember.where({feed: @feed})
    @users = User.all.select do |hash|
      hash[:id] != current_user.id
    end
    @users = @users.map do |user|
      {
          "name": user.name,
          "id": user.id,
          "member": !@feed_members.where({user: user}).empty?
      }
    end
    puts('giving back')
    puts(@users)
  end

  # GET /feeds/new
  def new
    @feed = Feed.new
  end

  # GET /feeds/1/edit
  def edit
  end

  # POST /feeds
  # POST /feeds.json
  def create
    @feed = Feed.new(feed_params)
    puts("calling job")


    respond_to do |format|
      puts 'hi'
      if @feed.save
        fm = FeedMember.new(feed: @feed, user: current_user)
        fm.save()
        PullFeedJob.perform_later(@feed.id)
        format.html { redirect_to @feed, notice: 'Feed was successfully created.' }
        format.json { render :show, status: :created, location: @feed }
      else
        puts @feed.errors
        format.html { render :new }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /feeds/1
  # PATCH/PUT /feeds/1.json
  def update
    respond_to do |format|
      if @feed.update(feed_params)
        format.html { redirect_to @feed, notice: 'Feed was successfully updated.' }
        format.json { render :show, status: :ok, location: @feed }
      else
        format.html { render :edit }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_member
    fm = FeedMember.where(feed: @feed, user: User.find(params['user_id'])).first_or_create
  end

  def remove_member
    fm = FeedMember.where(feed: @feed, user: User.find(params['user_id'])).delete_all
  end

  # DELETE /feeds/1
  # DELETE /feeds/1.json
  def destroy
    @feed.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feed
      @feed = Feed.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feed_params
      params.require(:feed).permit(:title, :link, :img_link).merge(owner_id: current_user.id)
    end

    def redirect_if_not_signed_in
      redirect_to login_path if !user_signed_in?
    end

    def check_owner
      puts('checking auth')
      puts(current_user.id.to_s)
      puts(@feed.owner_id.to_s)
      puts(current_user.id.to_s != @feed.owner_id.to_s)
      redirect_to feed_path(@feed) if current_user.id.to_s != @feed.owner_id.to_s
    end

end
