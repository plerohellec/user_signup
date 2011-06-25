class User < ActiveRecord::Base

  has_many :jobs

  # email address regex borrowed from http://www.regular-expressions.info/regexbuddy/email.html
  validates_format_of :email, :with => /^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i

  validates_uniqueness_of :email
  validates_presence_of :uuid

  # Arbitrarely chosen length for the UUID
  UUID_LEN = 16

  # Random string to be use in email signup url
  def generate_uuid
    chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    self.uuid = (0..UUID_LEN).collect { chars[Kernel.rand(chars.length)] }.join
  end

end
