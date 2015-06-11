class UserAdminController < ApplicationController
  wrap_parameters format: [:json, :xml]
  def index
    # defaults to most recent
    @users = User.order(created_at: :desc)



  end

  def get_users
    type = params[:type]

    if type == "MOST RECENT"
      @users = User.order(created_at: :desc)
    elsif type == "FIRST NAME"
      @users = User.order(:first_name)
    else
      @users = User.order(:last_name)
    end



    respond_to do |format|
      format.json { render json: @users }
    end

  end


  def edit

    @editUser = User.find(params[:id])
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


end
