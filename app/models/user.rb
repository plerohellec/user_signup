require 'digest'

class User < ActiveRecord::Base

  has_many :jobs
  accepts_nested_attributes_for :jobs,
                  :reject_if => proc { |attributes| attributes['title'].blank? &&
                                                    attributes['company_name'].blank? }

  # email address regex borrowed from http://www.regular-expressions.info/regexbuddy/email.html
  validates :email, :format => { :with => /^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i },
                    :presence => true,
                    :uniqueness => { :case_sensitive => false }

  validates :uuid,  :presence => true

  validates :first_name, :presence => true, :on => :update
  validates :last_name,  :presence => true, :on => :update
  validates :password,   :confirmation => true

  # need to create the hashed password out of the password
  before_save :hash_password

  # virtual attribute of the user
  attr_accessor :password

  # plug authlogic in
  acts_as_authentic do |c|
  end

  # Random string to be use in email signup url
  def generate_uuid
    chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    self.uuid = (0..UUID_LEN).collect { chars[Kernel.rand(chars.length)] }.join
  end

  # This methods relies on sendmail or postfix being setup on localhost
  # and being configured to deliver emails to the internet.
  # Will return true for success, false otherwise.
  def send_confirmation_email

    # we may get a command not found exception here
    begin
      f = IO.popen("/usr/sbin/sendmail -f \"#{EMAIL_SENDER}\" #{self.email}", "w")
    rescue Exception => e
      logger.error "send_confirmation_email: #{e}"
      return false
    end

    if !f
      logger.error "failed to invoke sendmail"
      return false
    end

    logger.debug "Sending mail to #{self.email}"

    f.write <<CONF_MAIL;
Date: #{Time.now}
Subject: User Signup App confirmation email
To: #{self.email}
From: #{EMAIL_SENDER}
Content-Type: text/html

Thanks for signing up with 'User Signup App'.<br>
To confirm your registration, please click on the link below:
&nbsp;<a href=#{confirmation_url}>Confirmation link</a>

<br><br>
'User Signup App Team'

CONF_MAIL

    f.close

    # Note that sendmail exiting with 0 does not guarantee the message was
    # delivered, but checking the exit code is better than nothing.
    logger.debug "sendmail exit code=#{$?}"

    return $?==0
  end

  # has the user been through step 2 already?
  def is_registered?
    # keep track of where we are: if no password in db
    # it means we still are at the regustration step
    (hashed_password_was && !hashed_password_was.empty?)
  end

  protected

  def confirmation_url
    "http://#{HOSTNAME}/users/register?uuid=#{self.uuid}"
  end

  def hash_password
    return unless password
    self.hashed_password = Digest::SHA2.hexdigest(password)
  end

end
