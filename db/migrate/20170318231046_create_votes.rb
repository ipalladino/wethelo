class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :amount
      t.belongs_to :user, index: true
      t.belongs_to :place, index: true

      t.timestamps
    end
  end
end
