class StaticPagesController < ApplicationController
  before_action :authenticate_user!

  def home

    @search = Search.new
    @countries = countries_list
    @regions = regions_list
    @industries = industries_list
    @sectors = Sector.order(:name)
    @vendors = Vendor.order(:name)
    @favSearchs = Search.order(created_at: :desc).where('user_id = ?',current_user.id).take(3)

    @news = Content.find_by("type_of_content = ? AND active = ?", "news", true)
    if @news == nil
      @news = Content.new
      @news.active = true
      @news.body_copy = ""
      @news.save
    end
    @layout = Content.find_by("type_of_content = ? AND active =?", "layout", true)
    if @layout == nil
      @layout = Content.new
      @layout.active = true
      @layout.type_of_content = "layout"
      @layout.column_one_content = ""
      @layout.column_two_content = ""
      @layout.column_three_content = ""
      @layout.save
    end
  end

  def profile
    @accepted_friendships = []
    @friendships = current_user.friendships.includes(:friend)
    @friendships.each do |f|
      @accepted_friendships << f if f.state == 'accepted'
    end
    # @current_pos
    # current_user.works.each do |work|
    #   if work.current?
    #     @current_pos = work
    #     p "CURRENT POS"
    #     p @current_pos
    #   end
    # end

    # if @current_pos.blank?
    #   @current_pos.job_title = "Unlisted"
    #   @current_pos.company = "Unlisted"
    #   @current_pos.industry = "Unlisted"
    #   @current_pos.country = "Unlisted"
    # end




  end

  def show_profile
    @user = User.find(params[:id])
    puts @user.inspect

    get_friendships
    @accepted_friendships = []
    @friendships = @user.friendships.includes(:friend)
    @friendships.each do |f|
      @accepted_friendships << f if f.state == 'accepted'
    end

    if @user == current_user
      redirect_to '/profile'
    end
  end

  def setting
  end

  def messages
  end
  def connections

  end

  def unauth
  end



  def get_friendships
    @friendships = current_user.friendships
    @friends = []
    @requested = []
    @pending = []
    @friendships.each { |friendship|
      if friendship.accepted?
        @friends << friendship.friend
      elsif friendship.pending?
        @pending << friendship.friend
      elsif friendship.requested?
        @requested << friendship.friend
      end
    }
  end

  def get_users
    @users = User.all
  end

  def content
    # needs default content to work correctly
    @news = Content.find_by("type_of_content = ? AND active = ?", "news", true)
    if @news == nil
      @news = Content.new
      @news.active = true
      @news.body_copy = ""
      @news.save
    end
    puts "NEWS:"
    puts @news.inspect

    @layout = Content.find_by("type_of_content = ? AND active = ?", "layout", true)
    if @layout == nil
      @layout = Content.new
      @layout.active = true
      @layout.type_of_content = "layout"
      @layout.column_one_content = ""
      @layout.column_two_content = ""
      @layout.column_three_content = ""
      @layout.save
    end
  end

  def countries_list
    ["United States", "Afghanistan", "Albania", "Algeria", "American Samoa", "Andorra", "Angola", "Anguilla", "Antarctica", "Antigua and Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Bosnia and Herzegowina", "Botswana", "Bouvet Island", "Brazil", "British Indian Ocean Territory", "Brunei Darussalam", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia", "Cameroon", "Canada", "Cape Verde", "Cayman Islands", "Central African Republic", "Chad", "Chile", "China", "Christmas Island", "Cocos (Keeling) Islands", "Colombia", "Comoros", "Congo", "Congo, the Democratic Republic of the", "Cook Islands", "Costa Rica", "Cote d'Ivoire", "Croatia (Hrvatska)", "Cuba", "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "East Timor", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "Falkland Islands (Malvinas)", "Faroe Islands", "Fiji", "Finland", "France", "France Metropolitan", "French Guiana", "French Polynesia", "French Southern Territories", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Gibraltar", "Greece", "Greenland", "Grenada", "Guadeloupe", "Guam", "Guatemala", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Heard and Mc Donald Islands", "Holy See (Vatican City State)", "Honduras", "Hong Kong", "Hungary", "Iceland", "India", "Indonesia", "Iran (Islamic Republic of)", "Iraq", "Ireland", "Israel", "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Korea, Democratic People's Republic of", "Korea, Republic of", "Kuwait", "Kyrgyzstan", "Lao, People's Democratic Republic", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libyan Arab Jamahiriya", "Liechtenstein", "Lithuania", "Luxembourg", "Macau", "Macedonia, The Former Yugoslav Republic of", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Martinique", "Mauritania", "Mauritius", "Mayotte", "Mexico", "Micronesia, Federated States of", "Moldova, Republic of", "Monaco", "Mongolia", "Montserrat", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands", "Netherlands Antilles", "New Caledonia", "New Zealand", "Nicaragua", "Niger", "Nigeria", "Niue", "Norfolk Island", "Northern Mariana Islands", "Norway", "Oman", "Pakistan", "Palau", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Pitcairn", "Poland", "Portugal", "Puerto Rico", "Qatar", "Reunion", "Romania", "Russian Federation", "Rwanda", "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines", "Samoa", "San Marino", "Sao Tome and Principe", "Saudi Arabia", "Senegal", "Seychelles", "Sierra Leone", "Singapore", "Slovakia (Slovak Republic)", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Georgia and the South Sandwich Islands", "Spain", "Sri Lanka", "St. Helena", "St. Pierre and Miquelon", "Sudan", "Suriname", "Svalbard and Jan Mayen Islands", "Swaziland", "Sweden", "Switzerland", "Syrian Arab Republic", "Taiwan, Province of China", "Tajikistan", "Tanzania, United Republic of", "Thailand", "Togo", "Tokelau", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Turks and Caicos Islands", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States Minor Outlying Islands", "Uruguay", "Uzbekistan", "Vanuatu", "Venezuela", "Vietnam", "Virgin Islands (British)", "Virgin Islands (U.S.)", "Wallis and Futuna Islands", "Western Sahara", "Yemen", "Yugoslavia", "Zambia", "Zimbabwe"]

  end

  def industries_list
    ["Education", "Services/Consulting", "IT/TelCo", "Financials/Insurance", "Healthcare/Pharma", "Retail/Consumer", "Industrials/Materials/Manufacturing", "Government", "Restricted", "Other", "Nonprofit", "Energy/Utilities"]
  end

  def regions_list
    ["EMEA", "North America", "APAC", "Latin America", "Restricted"]
  end






end
