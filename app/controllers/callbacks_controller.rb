class CallbacksController < Devise::OmniauthCallbacksController
    def linkedin
        # params.permit(:linked_in_url)
        auth = request.env["omniauth.auth"]

        # @user_linked = User.from_omniauth(request.env["omniauth.auth"],current_user)
        session["devise.linkedin_data"] = auth.info
        session["devise.linkedin_extra_data"] = auth.extra.raw_info

        p "AEOIHEAOUGHEAOUHGAE"
        p auth

        p '            '
        p '            '
        p '            '
        p auth.extra.raw_info



        # p auth.inspect
        # p auth[:raw_info]
        # p auth[:summary]
        # auth_url = auth.info.public_profile
        # p auth
        # user = User.find(current_user.id)
        # user.update_attribute(:linked_in_url, auth_url).permit!

        redirect_to '/setup_linkedin'
        # setup_linkedin_path
    end
end
