class AddReputationToPlace < ActiveRecord::Migration
  def change
    add_column :places, :reputation, :float
  end
end
