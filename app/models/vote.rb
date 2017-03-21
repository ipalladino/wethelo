class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :place
  validates :place_id, uniqueness: { scope: :user_id, message: 'No duplicate votes are allowed.' }
end
