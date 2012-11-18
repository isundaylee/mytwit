class AddRepostFieldsToTweets < ActiveRecord::Migration
  def change
      add_column :tweets, :precedent_id, :integer
      add_column :tweets, :origin_id, :integer
  end
end
