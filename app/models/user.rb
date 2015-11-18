class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  include ActiveModel::Dirty
  after_save :notify_changes, :if => proc { !last_sign_in_at_changed? && !invite_status_changed? && !encrypted_password_changed? && !invite_message_changed? }

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

  def self.from_omniauth(auth,user)

    # where()


    # auth.info.public_profile
    # @user.summary = auth.raw_info.summary
    # @user.linked_in_url = auth.info.public_profile
    # @user.profile_pic_url = auth.info.image
    # p @user
    # @user.save

    # positions = auth.positions

    # positions.each do |p|
    #   w = Work.new
    #   w.company = p.name
    #   w.industry = p.industry
    #   if p.size == "51-200 employees"

    #   elsif condition


    #   end
    # end

    # where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    #   user.provider = auth.provider
    #   user.uid = auth.uid
    #   user.email = auth.info.email
    # end
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

  def self.recs(current_user)
    recs = []
    wids = []

    friendships = current_user.friendships
    friends = []
    friendships.each { |friendship|
      friends << friendship.friend
    }

    works = Work.where("company = ?", current_user.current_pos["company"])

    if works.length > 1
      works.each do |w|
        if w.uid.to_s != current_user.uid && w.uid.to_s != ""
          wids << w.uid.to_s
        end
      end
    end

    close_users = User.where(:uid=>wids)
    close_users.each do |c|
      if recs.length < 3
        if !friends.include? c
          recs << c
        end
      end
    end

    works = Work.where("enterprise_size = ? OR industry = ?", current_user.current_pos["enterprise_size"], current_user.current_pos["industry"])

    all_wids = []

    works.each do |w|
      if w.uid.to_s != current_user.uid && w.uid.to_s != ""
        all_wids << w.uid.to_s
      end
    end

    users = User.where.not(id: current_user.id)
    users = users.where("big65 = ? OR fortune100 = ? OR sp500 = ? OR global1000 = ?", true, true, true, true)

    users = users.where(:uid=>all_wids)


    users.each do |i|
      if recs.length < 6
        random = users.sample
        if !friends.include? random
          recs << random
        end
      else
        break
      end
    end

    if recs.length < 6
      users = User.where.not(id: current_user.id)
      users.where(:uid=>all_wids)
      n = 6 - recs.length
      n.times do |i|
        random = users.sample
        if !friends.include? random
          if random != nil
            recs << random
          else
            recs << current_user
          end
        end
      end
    end

    return recs


  end





  def self.search(search,current_user)
    # puts "SEARCH:"
    # puts search.inspect
    # p search.results.class
    if search.results && search.results != ""
      res = JSON.parse(search.results)

      if res.is_a? Hash
        a = res
        res = []
        res << a
      end

      id_check = []
      id_final = []


      res.each_with_index do |int, index|
        if int != ""
          p "RES"
          p res
          # p int["vendor"]

          intentions = Intention.all
          id_check = []
          if int["vendor"] != "Any" && int["vendor"] != "No preference"
            # if int["vendor"] = "Any"
            # end
            v = Vendor.find_by("name = ?", int["vendor"])
            intentions = intentions.where(["vendor_id = ?", v.id]) if v != "Any" && v != "No preference"


          end
          if int["sector"] != "Any" && int["sector"] != "No preference"
            sect = Sector.find_by("name = ?", int["sector"])
            # p sect.inspect
            intentions = intentions.where(["sector_id = ?", sect.id]) if sect != "Any" && sect != "No preference"
          # p "intentions:"
          # p intentions.length
          end

          int_str = ""
          if int["intention"] == "Adopt"
            int_str = "ADOPTION"
          elsif int["intention"] == "Replace"
            int_str = "REPLACING"
          else
            int_str = int["intention"]
          end
          # p "INT STRING:"
          # puts int_str
          intentions = intentions.where(["intention = ?", int_str.upcase]) if int["intention"] != "Any" && int["intention"] != "No preference"
          intentions.each do |i|
            id_check << i.user_id
          end

          if index == 0
            id_final = id_check
          else
            id_final = id_final & id_check
          end
          p id_final
        end
      end

      user_uids = []

      id_final.each do | i |
        # user_uids << i.user_id.to_s + ".0"
        user_uids << i.to_s + ".0"
      end

    end



    wids = []
    # search all works and filter current and these
    # then find all users with the id's?
    works = Work.all

    works_arr = []

    # Create a multi dimensional array of results then merge them without duplicates later
    job_titles_results = []
    function_results = []

    if search[:clevel].present? && search[:clevel] == true
      arr = ["%Chief%", "%CIO%", "%CISO%", "%CSO%", "%CTO%", "%CMO%", "%CDO%", "%CEO%", "%COO%", "%CFO%"]
      works_clevel = works.where('job_title LIKE ? OR job_title LIKE ? OR job_title LIKE ? OR job_title LIKE ? OR job_title LIKE ? OR job_title LIKE ? OR job_title LIKE ? OR job_title LIKE ? OR job_title LIKE ? OR job_title LIKE ?', "%Chief%", "%CIO%", "%CISO%", "%CSO%", "%CTO%", "%CMO%", "%CDO%", "%CEO%", "%COO%", "%CFO%")
      job_titles_results << works_clevel
    end
    if search[:executive].present? && search[:executive] == true
      works_executive = works.where('job_title LIKE ? OR job_title LIKE ?', '%EVP%', '%Executive%')
      job_titles_results << works_executive
    end
    if search[:president].present? && search[:president] == true
      works_pres = works.where('job_title LIKE ? OR job_title LIKE ? OR job_title LIKE ? OR job_title LIKE ? OR job_title LIKE ?', '%EVP%', '%SVP%', '%President%', '%AVP%', '%VP%')
      job_titles_results << works_pres
    end
    if search[:director].present? && search[:president] == true
      works_dir = works.where('job_title LIKE ?', '%Director%')
      job_titles_results << works_dir
    end
    if search[:principal].present? && search[:principal] == true
      works_principal = works.where('job_title LIKE ?', '%Principal%')
      job_titles_results << works_principal
    end
    if search[:head].present? && search[:head] == true
      works_Head = works.where('job_title LIKE ?', '%Head%')
      job_titles_results << works_Head
    end
    if search[:senior].present? && search[:senior] == true
      senior = works.where('job_title LIKE ? OR job_title LIKE ? OR job_title LIKE ?', '%Senior%', '%SVP%', '%Snr%')
      job_titles_results << senior
    end
    if search[:lead].present? && search[:lead] == true
      lead = works.where('job_title LIKE ?', '%Lead%')
      job_titles_results << lead
    end
    if search[:manager].present? && search[:manager] == true
      manager = works.where('job_title LIKE ? OR job_title LIKE ?', '%Manager%', '%Mngr%')
      job_titles_results << manager
    end
    if search[:architect].present? && search[:architect] == true
      architect = works.where('job_title LIKE ? OR job_title LIKE ? OR job_title LIKE ? OR job_title LIKE ?', '%Architect%', '%Cloud%', '%Networking%', '%Storage%')
      function_results << architect
    end
    if search[:infrastructure].present? && search[:infrastructure] == true
      infrastructure = works.where('job_title LIKE ?', '%Infrastructure%')
      function_results << infrastructure
    end
    if search[:engineer].present? && search[:engineer] == true
      engineer = works.where('job_title LIKE ?', '%Engineer%')
      function_results << engineer
    end
    if search[:consultant].present? && search[:consultant] == true
      consultant = works.where('job_title LIKE ? OR job_title LIKE ?', '%Consultant%', '%Advisor%')
      function_results << consultant
    end
    if search[:security].present? && search[:security] == true
      security = works.where('job_title LIKE ?', '%Security%')
      function_results << security
    end
    if search[:analyst].present? && search[:analyst] == true
      analyst = works.where('job_title LIKE ?', '%Analyst%')
      function_results << analyst
    end
    if search[:administrator].present? && search[:administrator] == true
      administrator = works.where('job_title LIKE ? OR job_title LIKE ?', '%Administrator%', '%Admin%')
      function_results << administrator
    end
    if search[:risk].present? && search[:risk] == true
      risk = works.where('job_title LIKE ? OR job_title LIKE ?', '%Risk%', '%Compliance%')
      function_results << risk
    end
    titles = []
    p "JOB TITLES"
    p job_titles_results
    if job_titles_results.length > 1
      p "TITLE RESULTS"
      titles = job_titles_results[0]
      1.upto(job_titles_results.length - 1) do |i|
        titles = titles.union(job_titles_results[i])
      end
    elsif job_titles_results.length == 1
      titles = job_titles_results[0]
    end
    functions = []
    if function_results.length > 1
      p "FUNCTION RESULTS"
      functions = function_results[0]
      1.upto(function_results.length - 1) do |i|
        functions = functions.union(function_results[i])
      end
    elsif function_results.length == 1
      functions = function_results[0]
    end

    if titles.length > 0 && functions.length > 0
      p "DOUBLE"
      common_results = titles & functions
      p common_results
      works_arr << common_results
    elsif titles.length > 0
      p "TITLES"
      works_arr << titles
    elsif functions.length > 0
      p "FUNCTIONS"
      works_arr << functions
    else
      if job_titles_results.length > 0 || function_results.length > 0
        works = Work.none
      end
    end

    # Iterate over the multidimensional array and join them without duplicates or just use the first if there is only 1.
    # Uses active_record_union gem
    if works_arr.length > 1
      p works_arr[1].class
      works = works_arr[0]
      1.upto(works_arr.length - 1) do |i|
        works = works.union(works_arr[i])
      end
    elsif works_arr.length == 1
      p "WORKS 1"
      p works_arr[0]
      works = works_arr[0]
    end

    works = works.where('current'=>true)
    works = works.where(["industry LIKE ?", search[:industry]]) if search[:industry].present?
    works = works.where(["enterprise_size LIKE ?", search[:enterprise]]) if search[:enterprise].present?
    works = works.where(["region LIKE ?", search[:region]]) if search[:region].present?
    works = works.where(["country LIKE ?", search[:country]]) if search[:country].present?
    if search[:organization_type].present?
      if search[:organization_type] == "Publicly Traded"
        works = works.where('public'=>true)
      elsif search[:organization_type] == "Private"
        works = works.where('public'=>false)
      end
    end


    works = works.where(:uid=>user_uids) if search.results.present?

    works.each do |w|
      wids << w.uid.to_s
    end

    users = User.where.not(id: current_user.id)


    if (!search[:industry].present? && !search[:enterprise].present? && !search[:region].present? && !search[:country].present? && !search[:job_title].present? && !search[:organization_type].present? && !search.results.present? && !search[:clevel].present? && !search[:executive].present? && !search[:president].present? && !search[:director].present? && !search[:principal].present? && !search[:head].present? && !search[:senior].present? && !search[:lead].present? && !search[:manager].present? && !search[:architect].present? && !search[:infrastructure].present? && !search[:engineer].present? && !search[:consultant].present? && !search[:security].present? && !search[:administrator].present? && !search[:analyst].present? && !search[:risk].present?)
    else
      users = users.where(:uid=>wids)
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
    if @user_pos.blank? || @user_pos.nil?
      @user_pos = {
        "job_title" => "Unlisted job title",
        "company" => "Unlisted company",
        "enterprise_size" => "Unlisted enterprise size",
        "region" => "Unlisted region",
        "country" => "Unlisted country",
        "industry" => "Unlisted industry"
      }
    end

    if @user_pos['job_title'] == "" || @user_pos['job_title'].nil?
      @user_pos['job_title'] = "Unlisted job title"
    end

    if @user_pos['company'] == "" || @user_pos['company'].nil?
      @user_pos['company'] = "Unlisted company"
    end

    if @user_pos['enterprise_size'] == "" || @user_pos['enterprise_size'].nil?
      @user_pos['enterprise_size'] = "Unlisted enterprise size"
    end

    if @user_pos['region'] == "" || @user_pos['region'].nil?
      @user_pos['region'] = "Unlisted region"
    end

    if @user_pos['country'] == "" || @user_pos['country'].nil?
      @user_pos['country'] = "Unlisted country"
    end

    if @user_pos['industry'] == "" || @user_pos['industry'].nil?
      @user_pos['industry'] = "Unlisted industry"
    end

    return @user_pos
  end

  def unread_msgs
    @conversations ||= mailbox.conversations
    @unread = 0
    @conversations.each do |c|
      if c.is_unread?(self) && !c.last_sender.nil?
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

  def notify_changes
    if self.changed?
      @changes = self.changes

      admins = User.where(admin: true)

      Thread.new do
        admins.each do |a|
          EtrMailer.notify_changes_email(a,@changes,self, "profile").deliver_now
        end
        ActiveRecord::Base.connection.close
      end
    end
  end


end
