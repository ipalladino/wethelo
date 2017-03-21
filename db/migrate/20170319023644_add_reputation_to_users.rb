class AddReputationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :reputation, :float
  end
end
