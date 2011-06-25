class User < ActiveRecord::Base

  has_many :jobs

  validates_presence_of :email
  validates_presence_of :uuid

end
