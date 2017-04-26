class Advertisement < ActiveRecord::Base
  scope :published, ->{where active: true}
end
