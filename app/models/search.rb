class Search < ActiveRecord::Base

  belongs_to :user, foreign_key: 'user_id'

  def search_users
    users = User.all

    users = User.where(["industry LIKE ?", "%#{industry}%"]) if industry.present?

    return users

  end


end
