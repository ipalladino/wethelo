class FixPlacesColumnName < ActiveRecord::Migration
  def change
     rename_column :places, :votes, :recommendations
  end
end
