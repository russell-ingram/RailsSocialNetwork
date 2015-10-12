class EtrMailer < ApplicationMailer
  default from: "brontosauruss@gmail.com"

  def notify_changes_email(user,changes)
    @user = user
    @changes = changes
    mail(to: @user.email, subject: "User changes")
  end

  def send_invite_email(user)
    @user = user
    @user.invite_status = "pending"
    if Request.exists?(:uid => @user.uid)
      @req = Request.find_by("uid = ?", @user.uid)
      @req.invite_sent = true
      @req.save
    end
    require 'securerandom'
    random_string = SecureRandom.hex
    @user.password = random_string
    @password = random_string
    @user.save

    mail(to: @user.email, subject: "Invite to FITO")
  end

  def request_received_email(req)
    @req = req
    mail(to: @req.email, subject: "Your request to join FITO has been received")
    # should also send an e-mail to admin notifying about request
  end

  def reset_password_email(user,password)
    @name = user.full_name
    @password = password
    mail(to: user.email, subject: "Reset your FITO password")
  end

  def add_friend_email(sender, receiver, message)
    @receiver = receiver
    @sender = sender
    @message = message
    subject = "You have received a new FITO connection request: "+ "sender.full_name"+ " wants to connect with you"
    mail(to: receiver.email, subject: subject)
  end

  def friend_request_accepted_email(sender, receiver)
    @sender = sender
    @receiver = receiver
    subject = sender.full_name + " has accepted your FITO connection request"
    mail(to: receiver.email, subject: subject)
  end

  def message_received_email(sender, receiver, message)
    @sender = sender
    @receiver = receiver
    @message = message
    subject = "FITO - " + sender.full_name + " has sent you a message"
    mail(to: @receiver.email, subject: subject)
  end
   def message_replied_email(sender, receiver, message)
    @sender = sender
    @receiver = receiver
    @message = message
    subject = "FITO - " + sender.full_name + " has replied to your message"
    mail(to: @receiver.email, subject: subject)
  end

end
