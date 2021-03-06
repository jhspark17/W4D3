

class User < ApplicationRecord
  validates :username, presence: true
  validates :password_digest, presence: { message: 'Password can\'t be blank' } 
  validates :password, length: { minimum: 6, allow_nil: true }
  validates :session_token, presence: true, uniqueness: true

  after_initialize :ensure_session_token

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end 

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end


  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save!
    self.session_token
  end 

  def password
    @password
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)

    if user && is_password?(password)
      user
    elsif user.nil? 
      nil
    end
  end


end