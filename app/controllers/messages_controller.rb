class MessagesController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def msg_user
    @recip = User.find(params[:id])
  end

  def msg_all_users
    @recipients = User.all
  end


  def create
    puts params['recipients_id']
    users = params['recipients_id'].split(',')
    recipients = []

    x = User.where(id: users).all
    puts x
    # users.each do |user_id|
    #   rec = User.where(id: user_id.to_i)
    #   # puts rec.inspect
    #   recipients << rec
    # end
    # puts recipients
    flash.clear
    conversation = current_user.send_message(x, params[:message][:body], params[:message][:subject])
    flash[:success] = "Your message has been successfully sent!"

    # redirect_to conversation_path(1)
    puts "Mailboxer:"
    puts conversation
    puts "Details:"
    puts conversation.inspect
    if conversation
      puts "CONVERSATION PATH!!!!"
      flash[:success] = "Message sent!"

      redirect_to '/messages'
    else
      redirect_to '/messages'
    end
  end

  def recipients
    f_n = params[:term].split(' ').first
    if params[:term].split(' ').length > 1
      l_n = params[:term].split(' ').last
      @recipients = User.order(:first_name).where("first_name like ? AND last_name like?","%#{f_n}%", "%#{l_n}%")
    else
      @recipients = User.order(:first_name).where("first_name like ? OR last_name like?", "%#{f_n}%", "%#{f_n}%")
    end

    @friend_recipients = []

    current_user.friendships.each do |friendship|
      f = friendship.friend
      if @recipients.include? f
        f_rec = { "label" => f.full_name, "user_id" => f.id }
        @friend_recipients << f_rec
      end
    end

    render json: @friend_recipients


  end

  def admin_recipients
    f_n = params[:term].split(' ').first
    if params[:term].split(' ').length > 1
      l_n = params[:term].split(' ').last
      @recipients = User.order(:first_name).where("first_name like ? AND last_name like?","%#{f_n}%", "%#{l_n}%")
    else
      @recipients = User.order(:first_name).where("first_name like ? OR last_name like?", "%#{f_n}%", "%#{f_n}%")
    end

    @recipientsAll = []

    @recipients.each do |user|
      u_data = { "label" => user.full_name, "user_id" => user.id }
      @recipientsAll << u_data
    end

    render json: @recipientsAll


  end


end
