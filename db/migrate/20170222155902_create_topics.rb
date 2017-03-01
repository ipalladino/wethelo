class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :title
      t.string :description
      t.integer :votes

      t.timestamps
    end
  end
end
