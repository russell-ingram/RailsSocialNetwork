class UserAdminController < ApplicationController
  wrap_parameters format: [:json, :xml]
  before_action :authenticate_user!
  before_action :admin_user, :only => [:index, :destroy, :new, :create, :upload, :uploadFile, :edit]

  def index
    # defaults to most recent
    @users = User.order(created_at: :desc)
    @requests = Request.where("accepted = ?", false)
    require 'will_paginate/array'
    @users = @users.paginate(page: params[:page], per_page: 10)

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

    @users_arr = []
    @users.each do |f|
      @u = {}
      @u['user'] = f
      @u['work'] = f.current_pos
      @users_arr << @u
    end

    respond_to do |format|
      format.json { render json: @users_arr }
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
    @usersRaw.each do |u|
      work = u.current_pos
      u.employer = work.company
      u.industry = work.industry
    end
    p @usersRaw
    render json: @usersRaw
  end


  def edit
    if User.exists?(['id = ?', params[:id]])
      @editUser = User.find(params[:id])
    else
      @editUser = User.find_by("uid = ?", params[:id])
    end
    @editUser.works ||= Work.new
    if @editUser.works.length < 3
      if @editUser.works[0].blank?
        @editUser.works << Work.new
      end
      if @editUser.works[1].blank?
        @editUser.works << Work.new
      end
      if @editUser.works[2].blank?
        @editUser.works << Work.new
      end
    end
    @countries = countries_list
    @industries = industries_list
  end

  def edit_self
    p "EDIT SELF LOADED"
    @editUser = current_user
    @editUser.works ||= Work.new
    if @editUser.works.length < 3
      if @editUser.works[0].blank?
        @editUser.works << Work.new
      end
      if @editUser.works[1].blank?
        @editUser.works << Work.new
      end
      if @editUser.works[2].blank?
        @editUser.works << Work.new
      end
    end
    @countries = countries_list
    @industries = industries_list
  end

  def update
    @editUser = User.find(params[:id])
    if @editUser != current_user
      admin_user
    end
    if params[:commit] == "Onboard"

      @newUser = @editUser
      @newUser.password = params[:password]

      if @editUser.update(@newUser)
        @editUser.save
        sign_in(@editUser, :bypass => true)
        render json: @editUser
      else
        format.html { render :edit }
        format.json { render json: @editUser.errors, status: :unprocessable_entity }
      end

    else
      @newUser = user_params

      my_file = params[:user][:profile_pic_url]
      # uploader = ProfilepicUploader.new
      # uploader.store!(my_file)

      # profile_pic = File.basename(params[:user][:profile_pic_url])
      # puts "identifier"
      # puts profile_pic
      if @editUser != current_user
        if params[:user][:admin] == "Admin" || params[:user][:admin] == true || params[:user][:admin] == "true"
          @newUser[:admin] = true
        else
          @newUser[:admin] = false
        end
      end

      respond_to do |format|
        if @editUser.update(@newUser)
          @editUser.save
          # if uploader.url
            # @editUser.update_columns(profile_pic_url: uploader.filename)
          # end
          if @editUser == current_user
            if current_user.sign_in_count < 2
              format.html { redirect_to '/home' }
            else
              format.html { redirect_to '/profile' }
            end
          else
            format.html { redirect_to '/admin' }
          end
        else
          format.html { render :edit }
          format.json { render json: @editUser.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def setup_linkedin
    # p request.env["omniauth.auth"]
    # p session["devise.linkedin_data"]['raw_info']

    # @user = current_user
    # @user.linkedin_pic_url = session["devise.linkedin_extra_data"]['pictureUrls']['values'][0]
    # p "USER INFO AFTER UPDATE"
    # @user.linked_in_url = session["devise.linkedin_data"]['urls']['public_profile']
    # @user.summary = session["devise.linkedin_extra_data"]['summary']

    # @user.save
  end


  def update_settings
    @type = params[:type]
    @setting = params[:setting]
    @user = current_user

    if @type == 'message'
      @user.message_notifications = @setting
    elsif @type == 'connection'
      @user.connection_notifications = @setting
    elsif @type == 'adminProfile'
      @user.admin_profile_notifications = @setting
    elsif @type == 'adminRequest'
      @user.admin_request_notifications = @setting
    elsif @type == 'adminActivation'
      @user.admin_activation_notifications = @setting
    end

    @user.save
    render json: @type
  end


  def setup_user
    @editUser = User.find(params[:id])
    if @editUser != current_user
      admin_user
    end
    if @editUser.works.length < 3
      if @editUser.works[0].blank?
        @editUser.works << Work.new
      end
      if @editUser.works[1].blank?
        @editUser.works << Work.new
      end
      if @editUser.works[2].blank?
        @editUser.works << Work.new
      end
    end

    @work = Work.find_by user_id: params[:id], current: true
    if @work.blank?
      @work = @editUser.works[0]
      @work.current = true
    end

    @editUser.password = params[:password] if params[:password].present?
    @editUser.first_name = params[:first_name] if params[:first_name].present?
    @editUser.last_name = params[:last_name] if params[:last_name].present?
    @work.company = params[:company] if params[:company].present?
    @work.industry = params[:industry] if params[:industry].present?
    @work.enterprise_size = params[:enterprise_size] if params[:enterprise_size].present?
    @work.region = params[:region] if params[:region].present?
    @work.country = params[:country] if params[:country].present?
    @work.public = params[:public] if params[:public].present?


    if @editUser.save
      @work.save
      @req = Request.find_by uid: @editUser.uid
      @req.accepted = true
      @req.save
      sign_in(@editUser, :bypass => true)
      render json: @editUser
    else
      format.html { render :edit }
      format.json { render json: @editUser.errors, status: :unprocessable_entity }
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


    @editUser.works ||= Work.new
    if @editUser.works.length < 3
      if @editUser.works[0].blank?
        @editUser.works << Work.new
      end
      if @editUser.works[1].blank?
        @editUser.works << Work.new
      end
      if @editUser.works[2].blank?
        @editUser.works << Work.new
      end
    end
    if params[:id].present?
      @req = Request.find(params[:id])
      @editUser.first_name = @req.first_name
      @editUser.last_name = @req.last_name
      @editUser.email = @req.email
      @editUser.works[0].job_title = @req.job_title
      @editUser.works[0].company = @req.company
      @editUser.works[0].current = true
      @editUser.linked_in_url = @req.linked_in
    end
    @countries = countries_list
    @industries = industries_list
  end

  def create
    @editUser = User.new(new_user_params)

    require 'securerandom'
    random_string = SecureRandom.hex
    @editUser.password = random_string

    uid = rand(36**8).to_s(36)
    @editUser.uid = uid
    @editUser.works.each do |w|
      w.uid = uid
      w.save
    end

    if Request.exists?(:email => @editUser.email)
      @req = Request.find_by('email = ?', @editUser.email)
      @req.uid = uid
      @req.save
    end
    @countries = countries_list
    @industries = industries_list


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

    # survey_id = xlsx.sheets[0].to_i
    # s = Survey.new
    # s.survey_id = survey_id

    # Intention.delete_all()
    # Vendor.delete_all()
    # Sector.delete_all()

    # s.save

    xlsx.each_with_pagename do |name, sheet|

      if name.length < 3
        puts name
        # xlsx.default_sheet = sheet
        sheet.each_row_streaming do |row|
          y = row[0].coordinate.row

          # ignoring the first rows that are headers and/or empty
          if y > 2
            uid = row[4].value
            u = User.find_by("uid = ?", uid)
            # begin user exists check
            if u
              # do nothing to user
              n = 28
              if !row[10].value.nil?
              else
                n = 30
              end
              # # iterate through columns w/ survey for results upload
              # xlsx.last_column
              n.upto(sheet.last_column) do |index|

                if sheet.column(index)[y] && !sheet.column(index)[0].nil?

                  arr = sheet.column(index)[0].split('_')
                  vendor_name = arr[0]
                  vid = arr[1]
                  sector_name = arr[2]
                  sid = arr[3]

                  v = Vendor.find_by("vid = ?", vid)
                  if v
                  else
                    v = Vendor.new
                    v.name = vendor_name
                    v.vid = vid
                    v.save
                  end
                  sect = Sector.find_by("sid = ?", sid)
                  if sect
                  else
                    sect = Sector.new
                    sect.name = sector_name
                    sect.sid = sid
                    sect.save
                  end


                  i = Intention.new
                  i.survey_id = name.to_i
                  i.vendor_id = v.id
                  i.sector_id = sect.id
                  i.user_id = u.uid
                  i.intention = sheet.column(index)[y]


                  puts "INTENTION:"
                  puts i.inspect
                  i.save
                end
              end
            else
              u = User.new
              u.works = []
              w = Work.new
              u.uid = uid
              u.email = row[0].value
              u.first_name = row[1].value
              u.last_name = row[2].value
              u.password = "password"
              # # this needs to be based on organizations in db later
              w.company = row[7].value
              # # this should work with normal titles, but is using standard title for now
              w.job_title = row[9].value
              p row[10].value
              p row[11].value
              p row[12].value
              p row[13].value
              p row[14].value
              p row[16].value
              p row[17].value
              p row[18].value
              p row[19].value
              n = 28
              if !row[10].value.nil?
                w.industry = row[10].value
                w.enterprise_size = row[11].value.capitalize
                w.region = row[12].value
                w.footprint = row[13].value
                w.country = row[14].value
                w.uid = u.uid
                w.current = true
                if row[16].value == "Public"
                  w.public = true
                else
                  w.public = false
                end
                u.works << w

                if row[18].value == "YES"
                  u.big65 = true
                else
                  u.big65 = false
                end
                if row[20].value == "YES"
                  u.sp500 = true
                else
                  u.sp500 = false
                end
                if row[21].value == "YES"
                  u.fortune100 = true
                else
                  u.fortune100 = false
                end
                if row[22].value == "YES"
                  u.global1000 = true
                else
                  u.global1000 = false
                end
                u.timezone = row[23].value
              else
                n = 30
                w.industry = row[12].value
                w.enterprise_size = row[12].value.capitalize
                w.region = row[13].value
                w.footprint = row[14].value
                w.country = row[15].value
                w.uid = u.uid
                w.current = true
                if row[17].value == "Public"
                  w.public = true
                else
                  w.public = false
                end
                u.works << w

                if row[19].value == "YES"
                  u.big65 = true
                else
                  u.big65 = false
                end
                if row[21].value == "YES"
                  u.sp500 = true
                else
                  u.sp500 = false
                end
                if row[22].value == "YES"
                  u.fortune100 = true
                else
                  u.fortune100 = false
                end
                if row[23].value == "YES"
                  u.global1000 = true
                else
                  u.global1000 = false
                end
                u.timezone = row[24].value
              end
              u.save

              # # iterate through columns w/ survey for results upload
              # xlsx.last_column
              n.upto(sheet.last_column) do |index|
                # p sheet.column(index)
                if sheet.column(index)[y] && !sheet.column(index)[0].nil?
                  # p sheet.column(index)
                  arr = sheet.column(index)[0].split('_')
                  vendor_name = arr[0]
                  vid = arr[1]
                  sector_name = arr[2]
                  sid = arr[3]

                  v = Vendor.find_by("vid = ?", vid)
                  if v
                  else
                    v = Vendor.new
                    v.name = vendor_name
                    v.vid = vid
                    v.save
                  end
                  sect = Sector.find_by("sid = ?", sid)
                  if sect
                  else
                    sect = Sector.new
                    sect.name = sector_name
                    sect.sid = sid
                    sect.save
                  end


                  i = Intention.new
                  i.survey_id = name.to_i
                  i.vendor_id = v.id
                  i.sector_id = sect.id
                  i.user_id = u.uid
                  i.intention = sheet.column(index)[y]


                  puts "INTENTION:"
                  puts i.inspect
                  i.save
                end
              end




            end
            # end user exists check
          end
          # end y!= 1 check
        end
        # end rows iteration
      end
      # end check of name
    end
    # end sheets iteration

    redirect_to '/admin/upload'

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
          @blocking <<friendship.friend
      end
    }
  end

  def user_params
    # puts params
    params.require(:user).permit(:first_name, :last_name, :email, :industry, :password, :employer, :location, :profile_pic_url, :position, :footprint, :linked_in_url, :enterprise_size, :region, :country, :emp_summary, :summary, :admin, :works_attributes => [:company, :industry, :enterprise_size, :region, :country, :summary, :id, :job_title, :footprint, :current, :start_date, :end_date, :public])
  end

  def new_user_params
    params.require(:user).permit(:first_name, :last_name, :email, :industry, :employer, :location, :profile_pic_url, :linked_in_url, :summary, :admin,:uid, :works_attributes => [:company,:industry, :enterprise_size, :uid, :region, :country, :summary, :id, :job_title, :footprint, :current, :start_date, :end_date, :public])
  end

  def req_params
    params.require(:request).permit(:id)
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
