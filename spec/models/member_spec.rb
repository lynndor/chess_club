require 'rails_helper'

RSpec.describe Member, type: :model do
  subject { described_class.new(name: 'Magnus', surname: 'Carlsen', email: 'magnus@example.com') }

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:surname) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should allow_value('test@example.com').for(:email) }
    it { should_not allow_value('invalid_email').for(:email) }
  end

  describe '#full_name' do
    it 'returns the concatenated name and surname' do
      expect(subject.full_name).to eq('Magnus Carlsen')
    end
  end

  describe 'rank assignment' do
    it 'assigns the last rank to a new member' do
      Member.create!(name: 'First', surname: 'User', email: 'first@example.com')
      last = Member.create!(name: 'Second', surname: 'User', email: 'second@example.com')
      expect(last.current_rank).to eq(Member.maximum(:current_rank))
    end
  end
end
