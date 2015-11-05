class EtrMailer < ApplicationMailer
  default from: "notifications@etrfito.com"
  default "Message-ID"=>"#{Digest::SHA2.hexdigest(Time.now.to_i.to_s)}@etrfito.com"
  before_action :get_logo

  def notify_changes_email(admins,changes, user, type)
    @user = user
    @changes = changes
    @type = type
    subject = "FITO: " + @user.full_name + " has changed his/her profile"

    admins.each do |a|
      if a.admin_profile_notifications
        @admin = a
        mail(to: a.email, subject: subject)
      end
    end
  end

  def send_invite_email(user, message)
    @user = user
    @message = message
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

    mail(to: @user.email, subject: "Your request to join FITO has been accepted!")
  end

  def user_send_invite_email(user, email)
    @user = user
    @email = email
    subject = @user.full_name + " has invited you to join FITO powered by ETR!"
    mail(to: @email, subject: subject)
  end

  def user_accepted_invite_email(admins, user)
    @user = user
    subject = @user.full_name + " has accepted the invite to join FITO!"

    admins.each do |a|
      @admin = a
      if a.admin_activation_notifications
        mail(to: a.email, subject: subject)
      end
    end

  end

  def request_received_email(req)
    @req = req
    mail(to: @req.email, subject: "Your request to join FITO has been received")
  end

  def admin_request_received_email(req, admins)
    @req = req
    admins.each do |a|
      if a.admin_request_notifications
        @admin = a
        mail(to: @admin.email, subject: "Your request to join FITO has been received")
      end
    end
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
    subject = "You have received a new FITO connection request: "+sender.full_name+ " wants to connect with you"
    if @receiver.connection_notifications && @receiver.sign_in_count > 0
      mail(to: receiver.email, subject: subject)
    end
  end

  def friend_request_accepted_email(sender, receiver)
    @sender = sender
    @receiver = receiver
    subject = @sender.full_name + " has accepted your FITO connection request"
    if @receiver.connection_notifications && @receiver.sign_in_count > 0
      mail(to: receiver.email, subject: subject)
    end
  end

  def message_received_email(sender, receiver, message)
    @sender = sender
    @receiver = receiver
    @message = message.html_safe
    subject = "FITO - " + @sender.full_name + " has sent you a message"
    if @receiver.message_notifications && @receiver.sign_in_count > 0
          mail(to: @receiver.email, subject: subject)
    end
  end

  def message_replied_email(sender, receiver, message)
    @sender = sender
    @receiver = receiver
    @message = message
    subject = "FITO - " + sender.full_name + " has replied to your message"
    if @receiver.message_notifications && @receiver.sign_in_count > 0
      mail(to: @receiver.email, subject: subject)
    end
  end

  def get_logo
    attachments.inline['email-footer-logo.png'] = File.read(Rails.root.join('app/assets/images/email-footer-logo.png'))
  end

end
