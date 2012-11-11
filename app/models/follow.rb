class Follow < ActiveRecord::Base
  attr_accessible :followee_id, :follower_id
  
  belongs_to :follower, :class_name => "User"
  belongs_to :followee, :class_name => "User"
  
end
