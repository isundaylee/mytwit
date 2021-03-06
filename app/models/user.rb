class User < ActiveRecord::Base
  
  has_many :tweets
  has_many :followings, foreign_key: 'follower_id', class_name: 'Follow', dependent: :destroy
  has_many :followees, through: :followings
  has_many :followedbys, foreign_key: 'followee_id', class_name: 'Follow', dependent: :destroy
  has_many :followers, through: :followedbys
  
  attr_accessible :email, :name, :password, :password_confirmation, :description
  before_save :downcase_email
  before_save :create_remember_token
  before_save :save_avatar
  has_secure_password
  
  EMAIL_REGEXP = /\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, format: {with: EMAIL_REGEXP}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: 6}
  validates :password_confirmation, presence: true
  validates :description, length: {maximum: 500}
  
  AVATAR_STORE_DIR = File.join Rails.root, 'public', 'avatar_store'
  
  def avatar_path
    "/avatar_store/" + (self.avatar || "default.jpg")
  end
  
  def avatar=(avatar)
    unless avatar.blank?
      @avatar_data = avatar
      self[:avatar] = SecureRandom.hex(16) + '.' + avatar.original_filename.split('.').last.downcase
    end
  end
    
  def has_followed?(user)
    !self.followees.where({id: user.id}).first.nil?
  end

  def has_mutual_relationship_with?(other)
    self.has_followed?(other) && other.has_followed?(self)
  end
  
  private
    
    def downcase_email
      self.email = self.email.downcase
    end
    
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
    
    def avatar_filename
      File.join AVATAR_STORE_DIR, self.avatar || "default.jpg"
    end
    
    def save_avatar
      if @avatar_data
        FileUtils.mkdir_p AVATAR_STORE_DIR
        
        File.open(avatar_filename, 'wb') do |f|
          f.write(@avatar_data.read)
        end
        
        @avatar_data = nil
      end
    end
  
end
