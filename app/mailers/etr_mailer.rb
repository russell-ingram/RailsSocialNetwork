class EtrMailer < ApplicationMailer
  default from: "brontosauruss@gmail.com"

  def notify_changes_email(user,changes)
    @user = user
    @changes = changes
    # puts "SENDING AN EMAIL TO:"
    # p @user.email
    mail(to: 'brontosauruss@gmail.com', subject: "User changes")
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

    mail(to: "brontosauruss@gmail.com", subject: "Invite to FITO")
  end

  def request_received_email(req)
    @req = req
    mail(to: @req.email, subject: "Your request to join FITO has been received")
  end
end
