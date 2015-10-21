class ErrorsController < ApplicationController
  # before_action :authenticate_user!
  def error404
    render status: :not_found
  end
end
