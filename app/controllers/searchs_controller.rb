class SearchsController < ApplicationController
  before_action :authenticate_user!

  def search
    @countries = countries_list
    @industries = industries_list
    @searchTags = []
    @spendingTags = []
    @sectors = Sector.order(:name)
    @vendors = Vendor.order(:name)

    @favSearchs = Search.order(created_at: :desc).where('user_id = ?',current_user.id).take(5)

    @search = Search.new(search_params)
    @users = User.search(@search,current_user)
    @length = @users.length
    @search.peers = @length
    @users = @users.paginate(page: params[:page], per_page: 25)

    # MUST save before format_results or won't work
    @search.save

    get_friendships

    results = []

    @has_intentions = false
    # converting results string back into accessible hash
    if @search.results != ''
      @spendingTags = format_results(@search, results)
      @has_intentions = true
    end

    render 'search_results'
  end

  def get_search
    @countries = countries_list
    @industries = industries_list
    @searchTags = []
    @spendingTags = []
    @sectors = Sector.order(:name)
    @vendors = Vendor.order(:name)

    @favSearchs = Search.order(created_at: :desc).where('user_id = ?',current_user.id).take(5)

    if params[:search].present?
      @search = Search.new(search_params)
    else
      @search = Search.find(params[:id])
    end

    @users = User.search(@search, current_user)
    @length = @users.length
    @search.peers = @length
    @users = @users.paginate(page: params[:page], per_page: 25)

    # MUST save before format_results or won't work
    @search.save

    get_friendships

    results = []
    @has_intentions = false
    if @search.results != ''
      @spendingTags = format_results(@search, results)
      @has_intentions = true
    end

    render 'search_results'

  end

  def search_results
    # @search = Search.new
    # get_users
    # @countries = countries_list

  end

  def new_search
    @countries = countries_list
    @industries = industries_list
    @search = Search.new
    @favSearchs = Search.order(created_at: :desc).where('user_id = ?',current_user.id)
    @sectors = Sector.order(:name)
    @vendors = Vendor.order(:name)
  end

  def save_favorite_search
    @search = Search.find(params[:searchData])
    p @search
    @search[:name] = params[:name]
    @search[:user_id] = current_user.id
    @search.save
    render json: @search
  end

  def delete_favorite_search
    @search = Search.find(params[:id])
    if @search.destroy
      redirect_to :back
    end
  end

  def get_friendships
    @friendships = current_user.friendships
    @friends = []
    @requested = []
    @pending = []
    @blocked = []
    @blocking = []
    @friendships.each { |friendship|
      if friendship.accepted?
        @friends << friendship.friend
      elsif friendship.pending?
        @pending << friendship.friend
      elsif friendship.requested?
        @requested << friendship.friend
      elsif friendship.blocked?
        @blocked << friendship.friend
      elsif friendship.blocking?
        @blocking << friendship.friend
      end
    }
  end

  def industries_list
    ["Education","Energy/Utilities", "Financials/Insurance", "Government", "Healthcare/Pharma", "Industrials/Materials/Manufacturing","IT/TelCo", "Nonprofit", "Retail/Consumer", "Services/Consulting", "Other"]
  end





  def countries_list
    ["United States", "Afghanistan", "Albania", "Algeria", "American Samoa", "Andorra", "Angola", "Anguilla", "Antarctica", "Antigua and Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Bosnia and Herzegowina", "Botswana", "Bouvet Island", "Brazil", "British Indian Ocean Territory", "Brunei Darussalam", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia", "Cameroon", "Canada", "Cape Verde", "Cayman Islands", "Central African Republic", "Chad", "Chile", "China", "Christmas Island", "Cocos (Keeling) Islands", "Colombia", "Comoros", "Congo", "Congo, the Democratic Republic of the", "Cook Islands", "Costa Rica", "Cote d'Ivoire", "Croatia (Hrvatska)", "Cuba", "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "East Timor", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "Falkland Islands (Malvinas)", "Faroe Islands", "Fiji", "Finland", "France", "France Metropolitan", "French Guiana", "French Polynesia", "French Southern Territories", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Gibraltar", "Greece", "Greenland", "Grenada", "Guadeloupe", "Guam", "Guatemala", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Heard and Mc Donald Islands", "Holy See (Vatican City State)", "Honduras", "Hong Kong", "Hungary", "Iceland", "India", "Indonesia", "Iran (Islamic Republic of)", "Iraq", "Ireland", "Israel", "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Korea, Democratic People's Republic of", "Korea, Republic of", "Kuwait", "Kyrgyzstan", "Lao, People's Democratic Republic", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libyan Arab Jamahiriya", "Liechtenstein", "Lithuania", "Luxembourg", "Macau", "Macedonia, The Former Yugoslav Republic of", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Martinique", "Mauritania", "Mauritius", "Mayotte", "Mexico", "Micronesia, Federated States of", "Moldova, Republic of", "Monaco", "Mongolia", "Montserrat", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands", "Netherlands Antilles", "New Caledonia", "New Zealand", "Nicaragua", "Niger", "Nigeria", "Niue", "Norfolk Island", "Northern Mariana Islands", "Norway", "Oman", "Pakistan", "Palau", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Pitcairn", "Poland", "Portugal", "Puerto Rico", "Qatar", "Reunion", "Romania", "Russian Federation", "Rwanda", "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines", "Samoa", "San Marino", "Sao Tome and Principe", "Saudi Arabia", "Senegal", "Seychelles", "Sierra Leone", "Singapore", "Slovakia (Slovak Republic)", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Georgia and the South Sandwich Islands", "Spain", "Sri Lanka", "St. Helena", "St. Pierre and Miquelon", "Sudan", "Suriname", "Svalbard and Jan Mayen Islands", "Swaziland", "Sweden", "Switzerland", "Syrian Arab Republic", "Taiwan, Province of China", "Tajikistan", "Tanzania, United Republic of", "Thailand", "Togo", "Tokelau", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Turks and Caicos Islands", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States Minor Outlying Islands", "Uruguay", "Uzbekistan", "Vanuatu", "Venezuela", "Vietnam", "Virgin Islands (British)", "Virgin Islands (U.S.)", "Wallis and Futuna Islands", "Western Sahara", "Yemen", "Yugoslavia", "Zambia", "Zimbabwe"]

  end

  def get_users
    @users = User.all
    @favSearchs = Search.order(created_at: :desc).where('user_id = ?',current_user.id)
  end

  def search_params
    params.require(:search).permit(:name, :industry, :enterprise, :organization_type, :region, :country, :job_title, :results, :peers, :clevel, :executive, :president, :director, :principal, :head, :senior, :lead, :manager, :architect, :infrastructure, :engineer, :consultant, :security, :analyst, :administrator, :risk)
  end

  def format_results(search,results)


    if @search.results[0] != '['
      @search.results.insert(0, '[')
      @search.results.insert(-1, ']')
    end
    l = search.results.length

    @search.results[l-1] = ''
    @search.results[0] = ''
    p "RESULTS FORMAT!!!"
    p search.results
    p search
    t = search.results.split('{')
    t.each do |r|
      p r
      if r != ''
        rl = r.length
        if r[rl-1] == ','
          res = r[0..(rl-3)]
          res_arr = res.split(',')
          res_obj = {}
          res_arr.each do |a|
            key = a.split(':')
            kl = key[0].length
            key[0][kl-1] = ''
            key[0][0] = ''
            res_obj[key[0]] = key[1]
          end
          results << res_obj
        elsif r[rl-1] == '}'
          res = r[0..(rl-2)]
          res_arr = res.split(',')
          res_obj = {}
          res_arr.each do |a|
            key = a.split(':')
            kl = key[0].length
            key[0][kl-1] = ''
            key[0][0] = ''
            res_obj[key[0]] = key[1]
          end
          results << res_obj
        end
      end
    end
    return results


  end

end
