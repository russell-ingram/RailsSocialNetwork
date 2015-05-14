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

  def search
    get_users
    get_friendships
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
    @news = Content.new

    @layout = Content.new
  end

end
