class CustomFailure < Devise::FailureApp
  def redirect_url
    if params[:commit] == 'Onboard'
      '/register'
    elsif params[:commit] == 'Reset'
      '/reset_password'
    else
      '/'
    end
  end

  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end
