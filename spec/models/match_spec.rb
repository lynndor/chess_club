require 'rails_helper'

RSpec.describe Match, type: :model do
  let(:player_one) { Member.create!(name: 'Magnus', surname: 'Carlsen', email: 'magnus@example.com') }
  let(:player_two) { Member.create!(name: 'Hikaru', surname: 'Nakamura', email: 'hikaru@example.com') }

  subject {
    described_class.new(
      player_one: player_one,
      player_two: player_two,
      result: 'player_one_wins'
    )
  }

  describe 'associations' do
    it { should belong_to(:player_one).class_name('Member') }
    it { should belong_to(:player_two).class_name('Member') }
  end

  describe 'enums' do
    it { should define_enum_for(:result).with_values(player_one_wins: 0, player_two_wins: 1, draw: 2) }
  end

  describe 'validations' do
    it { should validate_presence_of(:result) }
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is invalid without a result' do
    subject.result = nil
    expect(subject).not_to be_valid
    expect(subject.errors[:result]).to be_present
  end
end
