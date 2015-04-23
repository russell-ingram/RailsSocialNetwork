class FriendshipsController < ApplicationController

  before_filter :authenticate_user!

  def new
    if params[:friend_id]
      @friend = User.find(params[:friend_id])
      @friendship = current_user.friendships.new(friend: @friend)
    else
      flash[:error] = "Friend required"
    end

  end


  def create
    puts "create PARAMS:"
    puts params

    if params[:friendship] && params[:friendship].has_key?(:friend_id)
      @friend = User.find(params[:friendship][:friend_id])
      @friendship = current_user.friendships.new(friend: @friend)
      @friendship.save
      redirect_to '/connections'
    else
      flash[:error] = "Friend required"
      redirect_to '/search'
    end


  #   @friendship = current_user.friendships.build(:friend_id => params[:friend_id])
  #   if @friendship.save
  #     flash[:notice] = "Added friend."
  #     redirect_to '/connections'
  #   else
  #     flash[:notice] = "Unable to add friend."
  #     redirect_to '/search'
  #   end

  end


end
