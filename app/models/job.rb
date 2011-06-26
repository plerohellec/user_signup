class Job < ActiveRecord::Base
  belongs_to :user

  validate :title, :presence => true
  validate :company_name, :presence => true

end
