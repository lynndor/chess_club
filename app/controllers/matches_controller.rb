class MatchesController < ApplicationController
  def new
    @match = Match.new
    @members = Member.order(:current_rank)
  end

  def create
    @match = Match.new(match_params)
    if @match.save
      RankingService.update_rankings!(@match)
      redirect_to leaderboard_members_path, notice: 'Match was successfully recorded and rankings updated.'
    else
      @members = Member.order(:current_rank)
      render :new, status: :unprocessable_entity
    end
  end

  private

  def match_params
    params.require(:match).permit(:player_one_id, :player_two_id, :result)
  end
end
