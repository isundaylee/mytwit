class Tweet < ActiveRecord::Base
  
  belongs_to :user
  
  attr_accessible :content
  
  validates :content, presence: true, length: {minimum: 5, maximum: 140}
  
end
