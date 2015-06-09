class UserAdminController < ApplicationController
  wrap_parameters format: [:json, :xml]
  def index
    @users = User.all
  end

  def edit
    # puts "PARAMS:"
    # puts params[:id]
    @editUser = User.find(params[:id])
  end

  def update
    @editUser = User.find(params[:id])
    respond_to do |format|
      if @editUser.update(user_params)
        puts user_params
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
    params.require(:user).permit(:first_name, :last_name, :email, :industry, :employer, :location, :profile_pic_url)
  end

  def new_user_params
    params.require(:user).permit(:first_name, :last_name, :email, :industry, :employer, :location, :password, :password_confirmation, :profile_pic_url)
  end


end
