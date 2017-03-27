class AddVoteTypeToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :votetype, :integer, default: 0
  end
end
