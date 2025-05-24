class Member < ApplicationRecord
  validates :name, :surname, :email, presence: true
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  has_many :matches_as_player_one, class_name: 'Match', foreign_key: 'player_one_id'
  has_many :matches_as_player_two, class_name: 'Match', foreign_key: 'player_two_id'

  before_create :assign_rank

  def full_name
    "#{name} #{surname}"
  end

  private

  def assign_rank
    max_rank = Member.maximum(:current_rank) || 0
    self.current_rank = max_rank + 1
  end
end
