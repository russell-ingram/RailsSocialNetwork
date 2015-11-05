class Work < ActiveRecord::Base
  include ActiveModel::Dirty
  belongs_to :user

  after_save :notify_changes

  def notify_changes
    if self.changed?
      @changes = self.changes

      admins = User.where(admin: true)
      Thread.new do
        EtrMailer.notify_changes_email(admins,@changes,current_user, "work").deliver_now
        ActiveRecord::Base.connection.close
      end
    end
  end

  def work_params
    params.require(:work).permit(:company, :industry, :enterprise_size,:region, :country, :start_date, :end_date,:summary, :current,:public)
  end
end
