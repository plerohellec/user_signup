class Job < ActiveRecord::Base
  belongs_to :user

  validates :title, :presence => true
  validates :company_name, :presence => true
end
