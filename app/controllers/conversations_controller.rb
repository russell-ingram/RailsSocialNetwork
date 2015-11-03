class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_mailbox
  before_action :get_conversation, except: [:index]


  def index

    @has_friends = false
    @accepted_friendships = []
    @type = "MOST RECENT"
    @name = ""
    if params[:type]
      @type = params[:type]
    end
    if params[:name]
      @name = params[:name]
    end
    @friendships = current_user.friendships.includes(:friend)
    @friendships.each do |f|
      @accepted_friendships << f if f.state == 'accepted'
    end

    if @accepted_friendships.length > 0
      @has_friends = true
    end
    @all_conversations = []
    @unsorted_conversations = @mailbox.conversations
    @conversation_senders = []
    if @name == ""
      if @type == "first"
        @type = "FIRST NAME"

        @unsorted_conversations.each do |c|
          if !c.is_trashed?(current_user)
            if (!c.last_sender.nil?)
              @conversation_senders << {'conversation'=>c, 'sender'=>c.last_sender.first_name}
            else
              @conversation_senders << {'conversation'=>c, 'sender'=>"Deleted User"}
            end
          end
        end
        @all_conversations = @conversation_senders.sort_by do |c|
          c['sender']
        end

      elsif @type == "last"
        @type = "LAST NAME"
        @unsorted_conversations.each do |c|
          if !c.is_trashed?(current_user)
            if (!c.last_sender.nil?)
              @conversation_senders << {'conversation'=>c, 'sender'=>c.last_sender.last_name}
            else
              @conversation_senders << {'conversation'=>c, 'sender'=>"Deleted User"}
            end
          end
        end
        @all_conversations = @conversation_senders.sort_by do |c|
          c['sender']
        end
      elsif @type == "unread"
        @unread = []
        @read = []
        @unsorted_conversations.each do |c|
          if (!c.last_sender.nil?)
            if c.is_unread?(current_user)
              @unread << {'conversation'=>c, 'sender'=>''}
            else
              @read << {'conversation'=>c, 'sender'=>''}
            end
          end
        end
        @all_conversations = @unread + @read
      else
        @type = "MOST RECENT"
        @unsorted_conversations.each do |c|
          if !c.is_trashed?(current_user)
            @conversation_senders << {'conversation'=>c, 'sender'=>''}
          end
        end
        @all_conversations = @conversation_senders
      end
    else
      @type = "MOST RECENT"
      @unsorted_conversations.each do |c|
        if !c.is_trashed?(current_user)
          if !c.last_sender.nil?
            if c.last_sender.full_name.downcase.include?(@name)
              @conversation_senders
              @conversation_senders << {'conversation'=>c, 'sender'=>''}
            end
          end
        end
        @all_conversations = @conversation_senders
      end
    end

    @conversations = []
    # only finding non-deleted conversations
    @all_conversations.each do |c|
      @conversations << c['conversation']
    end


    require 'will_paginate/array'
    @conversations = @conversations.paginate(page: params[:page], per_page: 10)


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
    @recipients = @conversation.recipients
    Thread.new do
      @recipients.each do |u|

        if u.email != current_user.email
          EtrMailer.message_replied_email(current_user, u, params[:body]).deliver_now
        end
      end
      ActiveRecord::Base.connection.close
    end

    @recipients.each do |r|
      @conversation.untrash(r)
    end
    redirect_to conversation_path(@conversation)
  end

  def sort_conversations
    # unfinished - will reapproach when conversations design is complete
    type = params[:type]
    # if type == "LAST NAME"
    #   @users = User.order(:last_name)
    # elsif type == "FIRST NAME"
    #   @users = User.order(:first_name)
    # else
    #   @users = User.order(created_at: :desc)
    # end
    # p "TYPE of CONVO:"
    # puts type
    @type = type
    @conversations = []

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
