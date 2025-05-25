require 'rails_helper'

RSpec.describe RankingService do
  let!(:player1) { Member.create!(name: 'A', surname: 'A', email: 'a@example.com', current_rank: 1) }
  let!(:player2) { Member.create!(name: 'B', surname: 'B', email: 'b@example.com', current_rank: 2) }
  let!(:player3) { Member.create!(name: 'C', surname: 'C', email: 'c@example.com', current_rank: 3) }

  def reload_players
    [player1, player2, player3].each(&:reload)
  end

  context 'when higher-ranked player wins' do
    it 'does not change any ranks' do
      match = Match.create!(player_one: player1, player_two: player2, result: 'player_one_wins')
      expect {
        RankingService.update_rankings!(match)
        reload_players
      }.not_to change { [player1.current_rank, player2.current_rank, player3.current_rank] }
    end
  end

  context 'when lower-ranked player wins' do
    it 'adjusts ranks correctly considering normalization' do
      match = Match.create!(player_one: player1, player_two: player3, result: 'player_two_wins')
      RankingService.update_rankings!(match)
      reload_players

      # After normalization, ranks should be sequential
      expect(player1.reload.current_rank).to eq(2)
      expect(player3.reload.current_rank).to eq(1)
      expect(player2.reload.current_rank).to eq(3)
    end
  end

  context 'when it is a draw and players are not adjacent' do
    it 'moves lower up by one' do
      match = Match.create!(player_one: player1, player_two: player3, result: 'draw')
      RankingService.update_rankings!(match)
      reload_players
      puts "Ranks after draw: #{[player1.current_rank, player2.current_rank, player3.current_rank]}"
      expect(player3.current_rank).to eq(2)
      expect(player1.current_rank).to eq(1)
    end
  end

  context 'when it is a draw and players are adjacent' do
    it 'does not change any ranks' do
      match = Match.create!(player_one: player2, player_two: player3, result: 'draw')
      expect {
        RankingService.update_rankings!(match)
        reload_players
      }.not_to change { [player2.current_rank, player3.current_rank] }
    end
  end

  it 'normalizes ranks to be unique and sequential' do
    player1.update!(current_rank: 5)
    player2.update!(current_rank: 10)
    player3.update!(current_rank: 15)
    RankingService.send(:normalize_ranks!)
    reload_players
    expect([player1.current_rank, player2.current_rank, player3.current_rank]).to eq([1,2,3])
  end

  it 'correctly updates ranks when 16th beats 10th among 16 members' do
    # Ensure a clean slate for this test
    Member.delete_all

    members = 16.times.map do |i|
      Member.create!(
        name: "Player#{i+1}",
        surname: "Test#{i+1}",
        email: "player#{i+1}@example.com",
        current_rank: i + 1
      )
    end
    player_10 = members[9]
    player_16 = members[15]

    match = Match.create!(player_one: player_10, player_two: player_16, result: 'player_two_wins')
    RankingService.update_rankings!(match)
    puts Member.order(:current_rank).pluck(:name, :current_rank)
    player_10.reload
    player_16.reload

    ranks = Member.order(:current_rank).pluck(:current_rank)
    expect(ranks).to eq((1..16).to_a)
    expect(player_16.current_rank).to eq(13)
    expect(player_10.current_rank).to eq(11)
  end
end
