class Content < ActiveRecord::Base

  mount_uploader :link_url, LinkUrlUploader # Tells rails to use this uploader for this model.

end
