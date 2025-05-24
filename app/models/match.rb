class Match < ApplicationRecord
  belongs_to :player_one, class_name: 'Member', foreign_key: 'player_one_id'
  belongs_to :player_two, class_name: 'Member', foreign_key: 'player_two_id'

  enum result: { player_one_wins: 0, player_two_wins: 1, draw: 2 }
  validates :result, presence: true
end
