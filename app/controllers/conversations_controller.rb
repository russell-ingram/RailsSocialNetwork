class ConversationsController < ApplicationController
  # before_action :authenticate_user!
  before_action :get_mailbox
  before_action :get_conversation, except: [:index]


  def index
    # flash[:success] = "MESSAGE SENT"
    @conversations = @mailbox.inbox.paginate(page: params[:page], per_page: 10)
    @sentconversations = @mailbox.sentbox.paginate(page: params[:page], per_page: 10)

  end

  def show
    # puts "CONVERSATION?"
    # puts @conversation.inspect
    @conversation.mark_as_read(current_user)
    @receipts = @mailbox.receipts_for(@conversation)
    @messages = @conversation.messages
    @recipients = @conversation.recipients
  end

  def delete
    @conversation.move_to_trash(current_user)
    redirect_to "/messages"
  end

  def reply
    current_user.reply_to_conversation(@conversation, params[:body])
    redirect_to conversation_path(@conversation)
  end

  def sort_conversations
    # unfinished - will reapproach when conversations design is complete
    type = params[:type]
    if type == "LAST NAME"
      @users = User.order(:last_name)
    elsif type == "FIRST NAME"
      @users = User.order(:first_name)
    else
      @users = User.order(created_at: :desc)
    end

  end


  private

  def get_mailbox
    @mailbox ||= current_user.mailbox
    # puts "MAILBOX:"
    # puts @mailbox.inspect
  end

  def get_conversation
    @conversation ||= @mailbox.conversations.find(params[:id])
  end

  def get_box
    if params[:box].blank? or !["inbox","sent","trash"].include?(params[:box])
      params[:box] = 'inbox'
    end
    @box = params[:box]
  end

end
