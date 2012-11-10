class Tweet < ActiveRecord::Base
  
  belongs_to :user
  
  attr_accessible :content
  
  validates :content, presence: true, length: {minimum: 5, maximum: 140}
  before_save :remove_linebreaks
  
  private
  
    def remove_linebreaks
      self.content = self.content.split("\n").join(' ')
    end
  
end
