class StaticPagesController < ApplicationController
  before_action :authenticate_user!

  def home
    @news = Content.find_by("type_of_content = ? AND active = ?", "news", true)
    @layout = Content.find_by("type_of_content = ? AND active =?", "layout", true)
  end

  def profile
  end

  def show_profile
    @user = User.find(params[:id])
    get_friendships
  end

  def setting
  end

  def messages
  end
  def connections

  end



  def get_friendships
    @friendships = current_user.friendships
    @friends = []
    @requested = []
    @pending = []
    @friendships.each { |friendship|
      if friendship.accepted?
        @friends << friendship.friend
      elsif friendship.pending?
        @pending << friendship.friend
      elsif friendship.requested?
        @requested << friendship.friend
      end
    }
  end

  def get_users
    @users = User.all
  end

  def content
    # needs default content to work correctly
    @news = Content.find_by("type_of_content = ? AND active = ?", "news", true)
    if @news == nil
      @news = Content.new
      @news.active = true
      @news.body_copy = ""
      @news.save
    end
    puts "NEWS:"
    puts @news.inspect

    @layout = Content.find_by("type_of_content = ? AND active = ?", "layout", true)
    if @layout == nil
      @layout = Content.new
      @layout.active = true
      @layout.type_of_content = "layout"
      @layout.column_one_content = ""
      @layout.column_two_content = ""
      @layout.column_three_content = ""
      @layout.save
    end
  end

end
