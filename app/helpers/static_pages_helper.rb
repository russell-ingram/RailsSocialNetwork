module StaticPagesHelper

	def connection_img(rec)

		if rec.profile_pic_url?

			rec.profile_pic_url

		else

			image_path('avatar-icons/avatar_0'+rand(1..9).to_s+'.svg')

		end

	end

end
