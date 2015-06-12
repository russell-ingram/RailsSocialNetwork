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
    conversation = current_user.send_message(x, params[:message][:body], params[:message][:subject])
    flash[:success] = "Message has been sent!"
    # redirect_to conversation_path(1)
    puts "Mailboxer:"
    puts conversation
    puts "Details:"
    puts conversation.inspect
    if conversation
      redirect_to conversation_path(conversation)
    else
      redirect_to '/admin/messages/new/all'
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
end
