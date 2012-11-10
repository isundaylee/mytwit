class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password
  
  EMAIL_REGEXP = /\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, format: {with: EMAIL_REGEXP}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: 6}
  validates :password_confirmation, presence: true
  
  before_save :generate_password_digest
  
  private
  
    def generate_password_digest
      
    end
  
end
