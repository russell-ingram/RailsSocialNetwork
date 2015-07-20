class EtrMailer < ApplicationMailer
  default from: "brontosauruss@gmail.com"

  def notify_changes_email(user,changes)
    @user = user
    @changes = changes
    # puts "SENDING AN EMAIL TO:"
    # p @user.email
    mail(to: 'brontosauruss@gmail.com', subject: "User changes")
  end
end
