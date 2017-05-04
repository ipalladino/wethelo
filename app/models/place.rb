class Place < ActiveRecord::Base
  has_many :votes, dependent: :destroy
  has_many :placepictures, :dependent => :destroy

  # attr_reader
  def recommendations
    self[:recommendations]
  end

  # virtual attribute
  def recommendations
    return self.votes.where(votetype: 0).length
  end

  def calculate_reputation
    votes = self.votes.where(votetype: 1)
    total_recomendations = self.votes.where(votetype: 0).length
    reputation = 0
    votes.each do |vote|
      if(vote.amount == 1)
        #positive vote! user reputation will apply directly
        if(vote.user.reputation != 0 && vote.user.reputation != nil)
          extra_rep = (vote.user.reputation / total_recomendations)
          reputation = reputation + vote.amount + extra_rep
        else
          reputation = reputation + vote.amount
        end
      else
        #negative vote! user reputation will apply inversely
        if(vote.user.reputation != 0 && vote.user.reputation != nil)
          extra_rep = (vote.user.reputation / total_recomendations)
          reputation = reputation + vote.amount - extra_rep
        else
          reputation = reputation + vote.amount
        end
      end
    end
    self.reputation = reputation
    self.save
  end
end
