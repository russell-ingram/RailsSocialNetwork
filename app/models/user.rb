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
      p res[0]
      if res[0]["vendor"] != "Any"
        # if res[0]["vendor"] = "Any"
        # end
        v = Vendor.find_by("name = ?", res[0]["vendor"])

        intentions = intentions.where(["vendor_id = ?", v.id]) if v != "Any"


      end
      if res[0]["sector"] != "Any"
        sect = Sector.find_by("name = ?", res[0]["sector"])
        # p sect.inspect
        intentions = intentions.where(["sector_id = ?", sect.id]) if sect != "Any"
      # p "intentions:"
      # p intentions.length
      end

      int_str = ""
      if res[0]["intention"] == "Adopt"
        int_str = "ADOPTION"
      elsif res[0]["intention"] == "Replace"
        int_str = "REPLACING"
      else
        int_str = res[0]["intention"]
      end
      p "INT STRING:"
      puts int_str
      intentions = intentions.where(["intention = ?", int_str.upcase]) if res[0]["intention"] != "Any"



      p "Intentions found:"
      p intentions.inspect
      user_uids = []

      intentions.each do | i |
        user_uids << i.user_id.to_s + ".0"
      end
      puts "USER IDS FROM INTENTIONS:"
      puts user_uids

    end



    wids = []
    # search all works and filter current and these
    # then find all users with the id's?
    works = Work.all

    works = works.where('current'=>true)
    works = works.where(["industry LIKE ?", search[:industry]]) if search[:industry].present?
    works = works.where(["enterprise_size LIKE ?", search[:enterprise]]) if search[:enterprise].present?
    works = works.where(["region LIKE ?", search[:region]]) if search[:region].present?
    works = works.where(["country LIKE ?", search[:country]]) if search[:country].present?
    works = works.where(["position LIKE ?", search[:job_title]]) if search[:job_title].present?
    if search[:organization_type].present?
      if search[:organization_type] == "Public"
        works = works.where('public'=>true)
      elsif search[:organization_type] == "Private"
        works = works.where('public'=>false)
      end
    end

    works = works.where(:uid=>user_uids) if user_uids.present?

    works.each do |w|
      wids << w.uid.to_s
    end

    # puts "WIDS:"
    # p wids

    users = User.all



    if (!search[:industry].present? && !search[:enterprise].present? && !search[:region].present? && !search[:country].present? && !search[:job_title].present? && !search[:organization_type].present? && !search.results.present?)
      p "NOTHING IS PRESENT SO WE ARE RETURNING EVERYTHING"
    else
      p "STUFF IS PRESENT"
      p wids
      users = users.where(:uid=>wids)
      p users.length
    end

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
    # @user_pos_clone = @user_pos.clone.tap {
    #   |h| h.each {|k,v|
    #     if h[k].blank?
    #       h[k] = "Unlisted"
    #     end
    #   }
    # }
    # p "CLONE:"
    # puts @user_pos_clone
    return @user_pos
  end

  def unread_msgs
    @conversations ||= mailbox.conversations
    @unread = 0
    @conversations.each do |c|
      if c.is_unread?(self)
        @unread += 1
      end
    end
    return @unread
  end

  def friendship_requests
    @requested_friendships = []
    @friendships = self.friendships.includes(:friend)
    @friendships.each do |f|
      @requested_friendships << f if f.state == 'requested'
    end
    return @requested_friendships.length
  end

end
