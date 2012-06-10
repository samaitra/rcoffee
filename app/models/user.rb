require 'digest'
class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :username, :password, :password_confirmation

  validates :password, :presence => true,
                       :confirmation => true,
                       :length => {:within => 6 ..40}

def self.authenticate(username, password)
    user = find_by_username(username)
    return nil  if user.nil?
    return user if user.has_password?(password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  before_save :encrypt_password

  def has_password?(password)
    encrypted_password == encrypt(password)
  end

  private

    def encrypt_password
      self.salt = make_salt unless has_password?(password)
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
