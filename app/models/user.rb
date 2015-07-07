class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  acts_as_messageable

  has_many :friendships
  has_many :friends, -> { where( friendship: { state: 'accepted' } ) }, :through => :friendships

  has_many :pending_user_friendships, -> { where( state: 'pending' ) },
                                      class_name: 'Friendship',
                                      foreign_key: :user_id

  has_many :pending_friends, through: :pending_user_friendships, source: :friend

  has_many :works
  accepts_nested_attributes_for :works, :allow_destroy => true, :reject_if => :all_blank

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:linkedin]


  mount_uploader :profile_pic_url, ProfilepicUploader

  has_many :searchs
  has_many :intentions

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

  def mailboxer_email(object)
    return nil
  end

  def full_name
    first_name + ' ' + last_name
  end

  def ent_no_caps
    if enterprise_size
      enterprise_size.capitalize
    else
      "Unlisted Size"
    end
  end

  def job_title_option
    if position
      position
    else
      "Unlisted Position"
    end
  end

  def self.search(search)
    # puts "SEARCH:"
    # puts search.inspect
    # p search.results.class
    if search.results && search.results != ""
      res = JSON.parse(search.results)
      # p res[0]
      intentions = Intention.all
      # p "Length:"
      # p intentions.length
      if res[0]["vendor"] != "Any"
        # if res[0]["vendor"] = "Any"
        # end
        v = Vendor.find_by("name = ?", res[0]["vendor"])
        intentions = intentions.where(["vendor_id = ?", v.id]) if v != "Any"
      end
      if res[0]["sector"] != "Any"
        sect = Sector.find_by("name = ?", res[0]["sector"])
        intentions = intentions.where(["sector_id = ?", sect.id]) if sect != "Any"
      end

      intentions = intentions.where(["intention = ?", res[0]["intention"].upcase]) if res[0]["intention"] != "Any"



      # p "Intentions found:"
      # p intentions.inspect
      user_ids = []
      intentions.each do | i |
        user_ids << i.user_id
      end
    end





    users = User.all

    users = users.where(["industry LIKE ?", search[:industry]]) if search[:industry].present?
    users = users.where(["enterprise_size LIKE ?", search[:enterprise]]) if search[:enterprise].present?
    users = users.where(["region LIKE ?", search[:region]]) if search[:region].present?
    users = users.where(["country LIKE ?", search[:country]]) if search[:country].present?
    users = users.where(["position LIKE ?", search[:job_title]]) if search[:job_title].present?
    users = users.where(["enterprise_size LIKE ?", search[:enterprise]]) if search[:enterprise].present?
    users = users.find(user_ids) if user_ids.present?

    return users
  end

  def current_pos
    @user_pos
    works.each do |work|
      if work.current?
        @user_pos = work
      end
    end
    if @user_pos.blank?
      @user_pos = {
        "job_title" => "Unlisted",
        "company" => "Unlisted",
        "enterprise_size" => "Unlisted",
        "region" => "Unlisted",
        "country" => "Unlisted",
        "industry" => "Unlisted"
      }
    end
    return @user_pos
  end

end
