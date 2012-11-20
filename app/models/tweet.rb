class Tweet < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :precedent, class_name: 'Tweet', foreign_key: 'precedent_id'
  belongs_to :origin, class_name: 'Tweet', foreign_key: 'origin_id'
  
  attr_accessible :content
  
  EMAIL_REGEXP = /\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/
  validates :content, presence: true, length: {minimum: 5, maximum: 140}
  before_save :remove_linebreaks
  before_save :translate_mentions
  
  RETWEET_PATH_MAX_LENGTH = 5
  
  def repost_path
    current = self.precedent
    result = []
    1.upto(RETWEET_PATH_MAX_LENGTH) do
      break if current.nil? or current == self.origin
      result << current
      current = current.precedent
    end
    # Append a nil to signal that there are omitted terms.
    result << nil if !current.nil? and current != self.origin
    return result
  end
  
  private
  
    def remove_linebreaks
      self.content = self.content.split("\n").join(' ')
    end

    def translate_mentions
      reg = Regexp::new(/@/.source + '(' + EMAIL_REGEXP.source + ')')
      self.content.gsub! reg do |mention|
        user = User.find_by_email(reg.match(mention)[1])
        if user
          "###{user.id}##"
        else
          mention
        end
      end
    end
  
end
