class AddDefaultValueToUsersReputationZero < ActiveRecord::Migration
  def change
    change_column :users, :reputation, :float, :default => 0
  end
end
