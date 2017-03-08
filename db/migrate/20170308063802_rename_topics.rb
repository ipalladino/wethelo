class RenameTopics < ActiveRecord::Migration
  def change
    rename_table :topics, :places
  end
end
