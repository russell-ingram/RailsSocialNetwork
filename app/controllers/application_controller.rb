class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    '/home'
  end
  def after_sign_out_path_for(resource_or_scope)
    '/login'
  end

  rescue_from ActiveRecord::RecordNotFound do
    # flash[:warning] = 'Resource not found.'
    redirect_back_or root_path
  end

  def redirect_back_or(path)
    redirect_to request.referer || path
  end


end
