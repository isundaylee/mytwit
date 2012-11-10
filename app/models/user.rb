class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  before_save :downcase_email
  before_save :create_remember_token
  has_secure_password
  
  EMAIL_REGEXP = /\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, format: {with: EMAIL_REGEXP}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: 6}
  validates :password_confirmation, presence: true
  
  private
    
    def downcase_email
      self.email = self.email.downcase
    end
    
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
  
end
