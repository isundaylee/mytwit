class CreateShorturls < ActiveRecord::Migration
  def change
    create_table :shorturls do |t|
      t.string :abbrev
      t.string :url

      t.timestamps
    end
  end
end
