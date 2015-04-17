class StaticPagesController < ApplicationController
  def home
    # before_filter :authenticate_user!
  end

  def profile
  end

  def setting
  end

  def messages
  end
  def connections
  end

  def search
    @users = User.all;
  end
end
