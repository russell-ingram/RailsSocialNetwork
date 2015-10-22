class FriendshipsController < ApplicationController

  before_action :authenticate_user!


  def index
    # if params[:type]
    #   @type = params[:type]
    # end


    @blocked_friendships, @pending_friendships, @requested_friendships, @accepted_friendships = [], [], [], []
    @friendships = current_user.friendships.order(created_at: :desc).includes(:friend)
    @friendships.each do |f|
      @blocked_friendships << f if f.state == 'blocked'
      @pending_friendships << f if f.state == 'pending'
      @requested_friendships << f if f.state == 'requested'
      if !params[:name]
        @accepted_friendships << f if f.state == 'accepted'
      else
        f_n = params[:name]
        p f.friend.full_name
        if f.friend.full_name.downcase.include?(f_n)
          @accepted_friendships << f
        end
      end
    end
    @friends = []
    @accepted_friendships.each do |a|
      @friends << a
    end
    require 'will_paginate/array'

    @user_pos = current_user.current_pos

    @friends = @friends.paginate(page: params[:page], per_page: 10)
  end

  # def new
    # if params[:friend_id]
    #   @friend = User.find(params[:friend_id])
    #   @friendship = current_user.friendships.new(friend: @friend)
    # else
    #   # flash[:error] = "Friend required"
    # end

  # end

  def accept
    @friendship = current_user.friendships.find(params[:id])
    if @friendship.accept_mutual_friendship!
      Thread.new do
        EtrMailer.friend_request_accepted_email(current_user, @friendship.friend).deliver_now
        ActiveRecord::Base.connection.close
      end
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

    @friend = User.find(params[:id])
    if params[:message].blank?
      @message = "This request did not include a message."
    else
      @message = params[:message]
    end
    @friendship = Friendship.request(current_user,@friend, @message)
    Thread.new do
      EtrMailer.add_friend_email(current_user, @friend, params[:message]).deliver_now
      ActiveRecord::Base.connection.close
    end
    respond_to do |format|
      if @friendship.new_record?
        format.html do
          # flash[:error] = "Something went wrong."
          format.json {render json: "Friend request sent"}
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
  end

  def destroy
    f_id = params[:id].to_i
    puts f_id.class
    # current_user.friendships.each do |f|
    #   if f.friend_id == f_id
    #     @friendship = f
    #   end

    # end
    @friendship = current_user.friendships.where(:friend_id => f_id)
    if @friendship[0].delete_mutual_friendship!
    else
    end
    redirect_to '/connections'
  end


  def filter
    type = params[:type]

    @friend_ids = []
    current_user.friendships.each do |f|
      @friend_ids << f.friend_id if f.state == 'accepted'
    end

    if type == 'FIRST NAME'
      @friends = User.order(:first_name).where(:id => @friend_ids)
    elsif type == 'LAST NAME'
      @friends = User.order(:last_name).where(:id => @friend_ids)
    else
      @friendships = current_user.friendships.order(created_at: :desc).includes(:friend)
      @friends = []
      @friendships.each do |f|
        @friends << f.friend if f.state == 'accepted'
      end
    end
    @friend_arr = []
    @friends.each do |f|
      @u = {}
      @u['user'] = f
      @u['work'] = f.current_pos
      @friend_arr << @u
    end

    respond_to do |format|
      format.json { render json: @friend_arr }
    end

  end


end
