class Friendship < ActiveRecord::Base

  belongs_to :user
  belongs_to :friend, :class_name => 'User', foreign_key: 'friend_id'

  state_machine :state, :initial => :pending do

    state :requested

    event :accept do
      transition any => :accepted
    end
  end

  def self.request(user1, user2)
    transaction do
      friendship1 = create(user: user1, friend: user2, state: 'pending')
      friendship2 = create(user: user2, friend: user1, state: 'requested')
    end
  end


end
