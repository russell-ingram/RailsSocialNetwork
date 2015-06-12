class UserAdminController < ApplicationController
  wrap_parameters format: [:json, :xml]
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
  end

  def update
    @editUser = User.find(params[:id])

    my_file = params[:user][:profile_pic_url]
    uploader = ProfilepicUploader.new
    uploader.store!(my_file)

    puts "UPLOADER:"
    puts uploader.filename

    # profile_pic = File.basename(params[:user][:profile_pic_url])
    # puts "identifier"
    # puts profile_pic

    respond_to do |format|
      if @editUser.update(user_params)
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
  end

  def create
    @editUser = User.new(new_user_params)
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

    xlsx = Roo::Excelx.new(xlsxFile.path)

    xlsx.each_with_pagename do |name, sheet|
      p sheet.row(1)
    end



    redirect_to '/admin/upload'
  end



  def user_params
    # puts params
    params.require(:user).permit(:first_name, :last_name, :email, :industry, :employer, :location, :profile_pic_url, :position, :footprint, :linked_in_url, :enterprise_size, :region, :country, :emp_summary)
  end

  def new_user_params
    params.require(:user).permit(:first_name, :last_name, :email, :industry, :employer, :location, :password, :password_confirmation, :profile_pic_url)
  end

  def countries_list
    ["United States", "Afghanistan", "Albania", "Algeria", "American Samoa", "Andorra", "Angola", "Anguilla", "Antarctica", "Antigua and Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Bosnia and Herzegowina", "Botswana", "Bouvet Island", "Brazil", "British Indian Ocean Territory", "Brunei Darussalam", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia", "Cameroon", "Canada", "Cape Verde", "Cayman Islands", "Central African Republic", "Chad", "Chile", "China", "Christmas Island", "Cocos (Keeling) Islands", "Colombia", "Comoros", "Congo", "Congo, the Democratic Republic of the", "Cook Islands", "Costa Rica", "Cote d'Ivoire", "Croatia (Hrvatska)", "Cuba", "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "East Timor", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "Falkland Islands (Malvinas)", "Faroe Islands", "Fiji", "Finland", "France", "France Metropolitan", "French Guiana", "French Polynesia", "French Southern Territories", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Gibraltar", "Greece", "Greenland", "Grenada", "Guadeloupe", "Guam", "Guatemala", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Heard and Mc Donald Islands", "Holy See (Vatican City State)", "Honduras", "Hong Kong", "Hungary", "Iceland", "India", "Indonesia", "Iran (Islamic Republic of)", "Iraq", "Ireland", "Israel", "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Korea, Democratic People's Republic of", "Korea, Republic of", "Kuwait", "Kyrgyzstan", "Lao, People's Democratic Republic", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libyan Arab Jamahiriya", "Liechtenstein", "Lithuania", "Luxembourg", "Macau", "Macedonia, The Former Yugoslav Republic of", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Martinique", "Mauritania", "Mauritius", "Mayotte", "Mexico", "Micronesia, Federated States of", "Moldova, Republic of", "Monaco", "Mongolia", "Montserrat", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands", "Netherlands Antilles", "New Caledonia", "New Zealand", "Nicaragua", "Niger", "Nigeria", "Niue", "Norfolk Island", "Northern Mariana Islands", "Norway", "Oman", "Pakistan", "Palau", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Pitcairn", "Poland", "Portugal", "Puerto Rico", "Qatar", "Reunion", "Romania", "Russian Federation", "Rwanda", "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines", "Samoa", "San Marino", "Sao Tome and Principe", "Saudi Arabia", "Senegal", "Seychelles", "Sierra Leone", "Singapore", "Slovakia (Slovak Republic)", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Georgia and the South Sandwich Islands", "Spain", "Sri Lanka", "St. Helena", "St. Pierre and Miquelon", "Sudan", "Suriname", "Svalbard and Jan Mayen Islands", "Swaziland", "Sweden", "Switzerland", "Syrian Arab Republic", "Taiwan, Province of China", "Tajikistan", "Tanzania, United Republic of", "Thailand", "Togo", "Tokelau", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Turks and Caicos Islands", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States Minor Outlying Islands", "Uruguay", "Uzbekistan", "Vanuatu", "Venezuela", "Vietnam", "Virgin Islands (British)", "Virgin Islands (U.S.)", "Wallis and Futuna Islands", "Western Sahara", "Yemen", "Yugoslavia", "Zambia", "Zimbabwe"]

  end


end
