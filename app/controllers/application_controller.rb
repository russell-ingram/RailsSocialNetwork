class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    '/home'
  end
  def after_sign_out_path_for(resource_or_scope)
    '/'
  end

  # rescue_from ActiveRecord::RecordNotFound do
  #   # flash[:warning] = 'Resource not found.'
  #   redirect_back_or root_path
  # end

  # def redirect_back_or(path)
  #   redirect_to request.referer || path
  # end

  unless Rails.application.config.consider_all_requests_local
    rescue_from ActionController::RoutingError, with: -> { render_404  }
    rescue_from ActionController::UnknownController, with: -> { render_404  }
    rescue_from ActiveRecord::RecordNotFound, with: -> { render_404  }
  end

  def render_404
    respond_to do |format|
      format.html { render template: 'errors/not_found', status: 404 }
      format.all { render nothing: true, status: 404 }
    end
  end


  protected
  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to '/'
    end
  end

end
