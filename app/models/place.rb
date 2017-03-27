class Place < ActiveRecord::Base
  has_many :votes, dependent: :destroy

  # attr_reader
  def recommendations
    self[:recommendations]
  end

  # virtual attribute
  def recommendations
    return self.votes.where(votetype: 0).length
  end
end
