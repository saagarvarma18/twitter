class User < ActiveRecord::Base

	attr_accessor :password, :skip_callback

  attr_accessible :email, :name, :password, :password_confirmation, :password_reset_token, :password_reset_sent_at

  has_many :microposts, :dependent => :destroy

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 

  validates :name, :presence => true, 
  				   :length => { :maximum => 50 }

  validates :email,:presence => true, 
  				   :format => { :with => email_regex },
  				   :uniqueness => { :case_sensitive => false }

  validates :password, :presence => true,
  					   :confirmation => true,
  					   :length => {:within => 6..40	}


  before_save :encrypt_password

  def has_password?(submitted_password)
    encrypted_password== encrypt(submitted_password)
  end

  def feed
    Micropost.where("user_id = ?",id)
  end

   def send_password_reset
    self.password_reset_token = Digest::SHA2.hexdigest("#{self.email}#{Time.now}")
    self.password_reset_sent_at = Time.zone.now
    self.skip_callback = true
    @arbid=Digest::SHA2.hexdigest("abcdef")
    self.password= @arbid[0,37]
    self.password_confirmation= @arbid[0,37]
    save!
    UserPassMailer.password_reset(self).deliver
  end

  class << self
      def authenticate(email, submitted_password)
        user=find_by_email(email)
        return nil if user.nil?
        return user if user.has_password?(submitted_password)
      end

      def authenticate_with_salt(id, cookie_salt)
        user= find_by_id(id)
        
        ( user && user.salt = cookie_salt) ? user:nil
      end
    end

  private

  	def encrypt_password
      return if self.skip_callback
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")      
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
