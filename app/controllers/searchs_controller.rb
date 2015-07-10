class SearchsController < ApplicationController
  def search
    @countries = countries_list
    @industries = industries_list
    @searchTags = []
    @spendingTags = []
    @sectors = Sector.order(:name)
    @vendors = Vendor.order(:name)

    @favSearchs = Search.order(created_at: :desc).where('user_id = ?',current_user.id)

    @search = Search.new(search_params)
    @users = User.search(@search)
    @search.peers = @users.length
    @search.save



    @newSearch = @search
    results = []

    @searchData = @search.to_json

    # converting results string back into accessible hash
    if @search.results != ''
      @spendingTags = format_results(@search, results)
    end

    # end conversion save results as tags

    render 'search_results'
  end

  def update_search
    @countries = countries_list
    @industries = industries_list
    @sectors = Sector.all
    @vendors = Vendor.all
    @searchTags = []
    @spendingTags = []
    @favSearchs = Search.order(created_at: :desc).where('user_id = ?',current_user.id)

    @search = Search.find(params[:id])
    @newSearch = search_params
    p @search

    @search.update(@newSearch)

    @users = User.search(@search)


    if @search.results != ''
      @spendingTags = format_results(@search, results)
    end

    render 'search_results'

  end

  def search_results
    @search = Search.new
    get_users
    @countries = countries_list

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
    puts "PARAMS:"
    @search = Search.find(params[:searchData]);
    @search[:user_id] = current_user.id
    @search[:results] = {"test"=> ["one"=>"1","two"=>"2"]}
    @search.save
    render json: @search
  end

  def delete_favorite_search
    @search = Search.find(params[:id])
    if @search.destroy
      redirect_to :back
    end
  end




  def industries_list
    ["Education", "Services/Consulting", "IT/TelCo", "Financials/Insurance", "Healthcare/Pharma", "Retail/Consumer", "Industrials/Materials/Manufacturing", "Government", "Restricted", "Other", "Nonprofit", "Energy/Utilities"]
  end





  def countries_list
    ["United States", "Afghanistan", "Albania", "Algeria", "American Samoa", "Andorra", "Angola", "Anguilla", "Antarctica", "Antigua and Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Bosnia and Herzegowina", "Botswana", "Bouvet Island", "Brazil", "British Indian Ocean Territory", "Brunei Darussalam", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia", "Cameroon", "Canada", "Cape Verde", "Cayman Islands", "Central African Republic", "Chad", "Chile", "China", "Christmas Island", "Cocos (Keeling) Islands", "Colombia", "Comoros", "Congo", "Congo, the Democratic Republic of the", "Cook Islands", "Costa Rica", "Cote d'Ivoire", "Croatia (Hrvatska)", "Cuba", "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "East Timor", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "Falkland Islands (Malvinas)", "Faroe Islands", "Fiji", "Finland", "France", "France Metropolitan", "French Guiana", "French Polynesia", "French Southern Territories", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Gibraltar", "Greece", "Greenland", "Grenada", "Guadeloupe", "Guam", "Guatemala", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Heard and Mc Donald Islands", "Holy See (Vatican City State)", "Honduras", "Hong Kong", "Hungary", "Iceland", "India", "Indonesia", "Iran (Islamic Republic of)", "Iraq", "Ireland", "Israel", "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Korea, Democratic People's Republic of", "Korea, Republic of", "Kuwait", "Kyrgyzstan", "Lao, People's Democratic Republic", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libyan Arab Jamahiriya", "Liechtenstein", "Lithuania", "Luxembourg", "Macau", "Macedonia, The Former Yugoslav Republic of", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Martinique", "Mauritania", "Mauritius", "Mayotte", "Mexico", "Micronesia, Federated States of", "Moldova, Republic of", "Monaco", "Mongolia", "Montserrat", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands", "Netherlands Antilles", "New Caledonia", "New Zealand", "Nicaragua", "Niger", "Nigeria", "Niue", "Norfolk Island", "Northern Mariana Islands", "Norway", "Oman", "Pakistan", "Palau", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Pitcairn", "Poland", "Portugal", "Puerto Rico", "Qatar", "Reunion", "Romania", "Russian Federation", "Rwanda", "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines", "Samoa", "San Marino", "Sao Tome and Principe", "Saudi Arabia", "Senegal", "Seychelles", "Sierra Leone", "Singapore", "Slovakia (Slovak Republic)", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Georgia and the South Sandwich Islands", "Spain", "Sri Lanka", "St. Helena", "St. Pierre and Miquelon", "Sudan", "Suriname", "Svalbard and Jan Mayen Islands", "Swaziland", "Sweden", "Switzerland", "Syrian Arab Republic", "Taiwan, Province of China", "Tajikistan", "Tanzania, United Republic of", "Thailand", "Togo", "Tokelau", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Turks and Caicos Islands", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States Minor Outlying Islands", "Uruguay", "Uzbekistan", "Vanuatu", "Venezuela", "Vietnam", "Virgin Islands (British)", "Virgin Islands (U.S.)", "Wallis and Futuna Islands", "Western Sahara", "Yemen", "Yugoslavia", "Zambia", "Zimbabwe"]

  end

  def get_users
    @users = User.all
    @favSearchs = Search.order(created_at: :desc).where('user_id = ?',current_user.id)
  end

  def search_params
    params.require(:search).permit(:name, :industry, :enterprise, :organization_type, :region, :country, :job_title, :results)
  end

  def format_results(search,results)
    l = @search.results.length
    @search.results[l-1] = ''
    @search.results[0] = ''
    t = @search.results.split('{')
    t.each do |r|
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
