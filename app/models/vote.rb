#vote types, 0 => recommendation, 1 => liked recommendation
class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :place
  validates :place_id, uniqueness: { scope: [:user_id, :votetype], message: 'No duplicate votes are allowed.' }
end
