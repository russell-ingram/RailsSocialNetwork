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
    @req = Request.find_by("uid = ?", @user.uid)
    @req.invite_sent = true
    @req.save
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
end
