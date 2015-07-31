class Content < ActiveRecord::Base

  mount_uploader :image_url, LinkUrlUploader # Tells rails to use this uploader for this model.

end
