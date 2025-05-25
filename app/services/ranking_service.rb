class RankingService
  class << self
    def update_rankings!(match)
      # Returns early if the match is invalid
      return unless valid_match?(match)

      player_one = match.player_one
      player_two = match.player_two

      #Sort players by their current rank to identify higher and lower ranked players
      higher_ranked_player, lower_ranked_player = order_by_rank(player_one, player_two)

      ActiveRecord::Base.transaction do
        case match.result
        # If the higher ranked player wins, no rank changes needed, so just return early
        when higher_player_win(higher_ranked_player, match)
          return

        # If it's a draw, adjust ranks accordingly (typically moving the lower player up)
        when 'draw'
          adjust_ranks_for_draw(higher_ranked_player, lower_ranked_player)

        else
          # Otherwise, lower ranked player won — adjust ranks with rank swapping logic
          adjust_ranks_for_lower_win(higher_ranked_player, lower_ranked_player)
        end

        # Normalize all ranks to ensure uniqueness and sequential order
        normalize_ranks!
      end
    end

    private

    def order_by_rank(player_one, player_two)
      [player_one, player_two].sort_by(&:current_rank)
    end

    def higher_player_win(higher_ranked_player, match)
      if higher_ranked_player == match.player_one
        'player_one_wins'
      else
        'player_two_wins'
      end
    end

    def adjust_ranks_for_draw(higher_ranked_player, lower_ranked_player)
      rank_difference =  (higher_ranked_player.current_rank - lower_ranked_player.current_rank).abs
      return if rank_difference == 1

      # Find the member just above the lower player
      above_member = member_above(lower_ranked_player)
      if above_member
        above_member.update_column(:current_rank, lower_ranked_player.current_rank)
      end
      lower_ranked_player.update_column(:current_rank, lower_ranked_player.current_rank - 1)
    end

    def adjust_ranks_for_lower_win(higher_ranked_player, lower_ranked_player)
      original_higher_rank = higher_ranked_player.current_rank
      original_lower_rank = lower_ranked_player.current_rank

      # Lower-ranked player moves up by half the rank difference (rounded down)
      move_up = (original_lower_rank - original_higher_rank) / 2
      new_rank = original_lower_rank - move_up

      shift_members_up_between(new_rank, original_lower_rank)

      # Move lower to new_rank
      lower_ranked_player.update_column(:current_rank, new_rank)

      # Reload higher in case their rank was shifted by the update above
      higher_ranked_player.reload

      # Always move higher down by one from their current position (not original)
      higher_ranked_player.update_column(:current_rank, higher_ranked_player.current_rank + 1)
    end

    def valid_match?(match)
      return false unless match.present?
      return false unless match.player_one && match.player_two
      return false if match.player_one == match.player_two
      return false unless match.player_one.current_rank && match.player_two.current_rank
      return false unless valid_result?(match.result)
      true
    end

    def normalize_ranks!
      Member.order(:current_rank).each_with_index do |member, idx|
        member.update_column(:current_rank, idx + 1)
      end
    end

    def member_above(lower_ranked_player)
      Member.find_by(current_rank: lower_ranked_player.current_rank - 1)
    end

    def shift_members_up_between(start_rank, end_rank)
      Member.where(current_rank: start_rank...end_rank).update_all('current_rank = current_rank + 1')
    end

    def valid_result?(result)
      Match.results.key?(result)
    end
  end
end
