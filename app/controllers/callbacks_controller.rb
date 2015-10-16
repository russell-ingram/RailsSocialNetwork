class CallbacksController < Devise::OmniauthCallbacksController
    def linkedin
        # params.permit(:linked_in_url)
        auth = request.env["omniauth.auth"]

        # @user_linked = User.from_omniauth(request.env["omniauth.auth"],current_user)
        # info = auth.info
        # session["devise.linkedin_extra_data"] = auth.extra.raw_info

        @user = current_user
        p "PICTURE:"
        p auth.extra.raw_info['pictureUrls']['values']
        @user.linkedin_pic_url = auth.extra.raw_info['pictureUrls']['values'][0]
        @user.linked_in_url = auth.info.urls.public_profile
        @user.summary = auth.extra.raw_info.summary

        @user.save

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
