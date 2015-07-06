class FriendshipsController < ApplicationController

  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_friendship


  def index
    @blocked_friendships, @pending_friendships, @requested_friendships, @accepted_friendships = [], [], [], []
    @friendships = current_user.friendships.includes(:friend)
    @friendships.each do |f|
      @blocked_friendships << f if f.state == 'blocked'
      @pending_friendships << f if f.state == 'pending'
      @requested_friendships << f if f.state == 'requested'
      @accepted_friendships << f if f.state == 'accepted'
    end
  end

  def new
    if params[:friend_id]
      @friend = User.find(params[:friend_id])
      @friendship = current_user.friendships.new(friend: @friend)
    else
      # flash[:error] = "Friend required"
    end

  end

  def accept
    @friendship = current_user.friendships.find(params[:id])
    if @friendship.accept_mutual_friendship!
      # flash[:success] = "You are now friends with #{@friendship.friend.full_name}"
    else
      # flash[:error] = 'Something went horribly wrong!'
    end
    redirect_to '/connections'
  end

  def block
    @friendship = current_user.friendships.find(params[:id])
    if @friendship.block_mutual_friendship!
      # flash[:success] = "You have blocked #{@friendship.friend.full_name} successfully"
    else
      # flash[:error] = 'Something went horribly wrong!'
    end
    redirect_to '/connections'
  end

  def edit
    @friendship = current_user.friendships.find(params[:id])
    @friend = @friendship.friend
  end



  def create

    if params[:friendship] && params[:friendship].has_key?(:friend_id)
      @friend = User.find(params[:friendship][:friend_id])
      @friendship = Friendship.request(current_user,@friend)
      respond_to do |format|
        if @friendship.new_record?
          format.html do
            # flash[:error] = "Something went wrong."
            redirect_to '/search'
          end
          format.json { render json: @friendship.to_json, status: :precondition_failed }
        else
          format.html do
            # flash[:success] = "Friend request sent."
            redirect_to '/connections'
          end
          format.json { render json: @friendship.to_json }
        end
      end
    else
      # flash[:error] = "Friend required"
      redirect_to '/search'
    end

  end


end
