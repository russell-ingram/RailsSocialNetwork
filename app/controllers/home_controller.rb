class HomeController < ApplicationController
  def index
    @newRequest = Request.new
  end
end
