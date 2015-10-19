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

    rec = User.where(id: users).all
    # users.each do |user_id|
    #   rec = User.where(id: user_id.to_i)
    #   # puts rec.inspect
    #   recipients << rec
    # end
    # puts recipients

    conversation = current_user.send_message(rec, params[:message][:body], params[:message][:subject])
    flash[:sent] = "Your message has been successfully sent!"

    # redirect_to conversation_path(1)

    if conversation
      flash[:sent] = "Message sent!"
      rec.each do |u|
        Thread.new do
          EtrMailer.message_received_email(current_user, u, params[:message][:body]).deliver_now
          ActiveRecord::Base.connection.close
        end

      end

      if !params[:msgAll].blank? and params[:msgAll] == "msgAll"
        redirect_to '/admin/messages/new/all'
      else
        redirect_to '/messages'
      end
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
