class Intention < ActiveRecord::Base
  has_one :vendor
  has_one :sector
  belongs_to :survey
  belongs_to :user
end
