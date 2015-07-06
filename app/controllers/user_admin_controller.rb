class UserAdminController < ApplicationController
  wrap_parameters format: [:json, :xml]
  before_action :authenticate_user!
  before_action :admin_user, :only => [:index, :update, :destroy, :new, :create, :upload, :uploadFile]

  def index
    # defaults to most recent
    @users = User.order(created_at: :desc)

  end
  # for filtering
  def get_users
    type = params[:type]

    if type == "LAST NAME"
      @users = User.order(:last_name)
    elsif type == "FIRST NAME"
      @users = User.order(:first_name)
    else
      @users = User.order(created_at: :desc)
    end



    respond_to do |format|
      format.json { render json: @users }
    end

  end

  def autocomplete_users
    f_n = params[:term].split(' ').first
    if params[:term].split(' ').length > 1
      l_n = params[:term].split(' ').last
      @usersRaw = User.order(:first_name).where("first_name like ? AND last_name like?","%#{f_n}%", "%#{l_n}%")
    else
      @usersRaw = User.order(:first_name).where("first_name like ? OR last_name like?", "%#{f_n}%", "%#{f_n}%")
    end

    @users = []
    # only returning the names
    @usersRaw.each do |u|
      @users << u.full_name
    end
    render json: @users

  end

  def search_users
    f_n = params[:term].split(' ').first
    if params[:term].split(' ').length > 1
      l_n = params[:term].split(' ').last
      @usersRaw = User.order(:first_name).where("first_name like ? AND last_name like?","%#{f_n}%", "%#{l_n}%")
    else
      @usersRaw = User.order(:first_name).where("first_name like ? OR last_name like?", "%#{f_n}%", "%#{f_n}%")
    end
    # returning all the user data
    render json: @usersRaw
  end


  def edit
    @editUser = User.find(params[:id])
    @countries = countries_list
    @industries = industries_list
  end

  def update
    @editUser = User.find(params[:id])
    @newUser = user_params

    my_file = params[:user][:profile_pic_url]
    uploader = ProfilepicUploader.new
    uploader.store!(my_file)

    puts "UPLOADER:"
    puts uploader.filename

    # profile_pic = File.basename(params[:user][:profile_pic_url])
    # puts "identifier"
    # puts profile_pic
    if params[:user][:admin] == "Admin" || params[:user][:admin] == true
      puts "CHANGED TO TRUE"
      @newUser[:admin] = true
    else
      puts "LEFT AS FALSE"
      @newUser[:admin] = false
    end

    puts "user:"
    puts @newUser

    respond_to do |format|
      if @editUser.update(@newUser)
        if uploader.url
          @editUser.update_columns(profile_pic_url: uploader.filename)
        end
        format.html { redirect_to '/admin' }
      else
        format.html { render :edit }
        format.json { render json: @editUser.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])

    if @user.destroy
      redirect_to '/admin'
    end
  end

  def new
    @editUser = User.new
    @countries = countries_list
  end

  def create
    @editUser = User.new(new_user_params)
    @editUser.password = "password"
    respond_to do |format|
      if @editUser.save
        format.html { redirect_to '/admin' }
        format.json { render :show, status: :created, location: @editUser }
      else
        format.html { render :new }
        format.json { render json: @editUser.errors, status: :unprocessable_entity }
      end
    end
  end


  def upload

  end

  def uploadFile
    require 'roo'

    xlsxFile = params[:file]

    xlsx = Roo::Excelx.new(xlsxFile.path,:minimal_load => true)
    # header = xlsx.first_row
    # p header
    survey_id = xlsx.sheets[0].to_i
    s = Survey.new
    s.survey_id
    # add date time
    s.save

    xlsx.each_row_streaming do |row|

      y = row[0].coordinate.row

      if y != 1
        u = User.find_by("uid = ?", row[0].value)

        if u
          # do stuff to edit existing user
        else
          u = User.new
          u.uid = row[0].value
          u.email = row[1].value
          u.first_name = row[2].value
          u.last_name = row[3].value
          u.password = "password"
          # this needs to be based on organizations in db later
          u.employer = row[5].value
          # this should work with normal titles, but is using standard title for now
          u.position = row[8].value
          u.industry = row[9].value
          u.enterprise_size = row[10].value
          u.region = row[11].value
          u.footprint = row[12].value
          u.country = row[13].value
          u.save

          # iterate through columns w/ survey for results upload
          22.upto(xlsx.last_column) do |index|
            arr = xlsx.column(index)[0].split('_')
            vendor_name = arr[0]
            sector_name = arr[1]

            v = Vendor.find_by("name = ?", vendor_name)
            if v
            else
              v = Vendor.new
              v.name = vendor_name
              v.save
            end
            sect = Sector.find_by("name = ?", sector_name)
            if sect
            else
              sect = Sector.new
              sect.name = sector_name
              sect.save
            end


            i = Intention.new
            i.survey_id = survey_id
            i.vendor_id = v.id
            i.sector_id = sect.id
            i.user_id = u.uid
            i.intention = xlsx.column(index)[y]
            i.save


          end
        end






      end

    end



    redirect_to '/admin/upload'
  end



  def user_params
    # puts params
    params.require(:user).permit(:first_name, :last_name, :email, :industry, :employer, :location, :profile_pic_url, :position, :footprint, :linked_in_url, :enterprise_size, :region, :country, :emp_summary, :summary, :admin)
  end

  def new_user_params
    params.require(:user).permit(:first_name, :last_name, :email, :industry, :employer, :location, :password, :password_confirmation, :profile_pic_url, :summary, :admin)
  end

  def countries_list
    ["United States", "Afghanistan", "Albania", "Algeria", "American Samoa", "Andorra", "Angola", "Anguilla", "Antarctica", "Antigua and Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Bosnia and Herzegowina", "Botswana", "Bouvet Island", "Brazil", "British Indian Ocean Territory", "Brunei Darussalam", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia", "Cameroon", "Canada", "Cape Verde", "Cayman Islands", "Central African Republic", "Chad", "Chile", "China", "Christmas Island", "Cocos (Keeling) Islands", "Colombia", "Comoros", "Congo", "Congo, the Democratic Republic of the", "Cook Islands", "Costa Rica", "Cote d'Ivoire", "Croatia (Hrvatska)", "Cuba", "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "East Timor", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "Falkland Islands (Malvinas)", "Faroe Islands", "Fiji", "Finland", "France", "France Metropolitan", "French Guiana", "French Polynesia", "French Southern Territories", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Gibraltar", "Greece", "Greenland", "Grenada", "Guadeloupe", "Guam", "Guatemala", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Heard and Mc Donald Islands", "Holy See (Vatican City State)", "Honduras", "Hong Kong", "Hungary", "Iceland", "India", "Indonesia", "Iran (Islamic Republic of)", "Iraq", "Ireland", "Israel", "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Korea, Democratic People's Republic of", "Korea, Republic of", "Kuwait", "Kyrgyzstan", "Lao, People's Democratic Republic", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libyan Arab Jamahiriya", "Liechtenstein", "Lithuania", "Luxembourg", "Macau", "Macedonia, The Former Yugoslav Republic of", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Martinique", "Mauritania", "Mauritius", "Mayotte", "Mexico", "Micronesia, Federated States of", "Moldova, Republic of", "Monaco", "Mongolia", "Montserrat", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands", "Netherlands Antilles", "New Caledonia", "New Zealand", "Nicaragua", "Niger", "Nigeria", "Niue", "Norfolk Island", "Northern Mariana Islands", "Norway", "Oman", "Pakistan", "Palau", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Pitcairn", "Poland", "Portugal", "Puerto Rico", "Qatar", "Reunion", "Romania", "Russian Federation", "Rwanda", "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines", "Samoa", "San Marino", "Sao Tome and Principe", "Saudi Arabia", "Senegal", "Seychelles", "Sierra Leone", "Singapore", "Slovakia (Slovak Republic)", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Georgia and the South Sandwich Islands", "Spain", "Sri Lanka", "St. Helena", "St. Pierre and Miquelon", "Sudan", "Suriname", "Svalbard and Jan Mayen Islands", "Swaziland", "Sweden", "Switzerland", "Syrian Arab Republic", "Taiwan, Province of China", "Tajikistan", "Tanzania, United Republic of", "Thailand", "Togo", "Tokelau", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Turks and Caicos Islands", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States Minor Outlying Islands", "Uruguay", "Uzbekistan", "Vanuatu", "Venezuela", "Vietnam", "Virgin Islands (British)", "Virgin Islands (U.S.)", "Wallis and Futuna Islands", "Western Sahara", "Yemen", "Yugoslavia", "Zambia", "Zimbabwe"]

  end

  def industries_list
    ["Education", "Services/Consulting", "IT/TelCo", "Financials/Insurance", "Healthcare/Pharma", "Retail/Consumer", "Industrials/Materials/Manufacturing", "Government", "Restricted", "Other", "Nonprofit", "Energy/Utilities"]
  end


  def admin_user
    if current_user.admin
      return true
    else
      redirect_to '/unauthorized'
    end
  end

end
