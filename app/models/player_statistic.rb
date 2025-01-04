class PlayerStatistic < ApplicationRecord
  belongs_to :player
  belongs_to :team
  belongs_to :season

  has_one :player_cards_statistic, dependent: :destroy
  has_one :player_dribbles_statistic, dependent: :destroy
  has_one :player_duels_statistic, dependent: :destroy
  has_one :player_fouls_statistic, dependent: :destroy
  has_one :player_games_statistic, dependent: :destroy
  has_one :player_goals_statistic, dependent: :destroy
  has_one :player_passes_statistic, dependent: :destroy
  has_one :player_penalty_statistic, dependent: :destroy
  has_one :player_shots_statistic, dependent: :destroy
  has_one :player_substitutes_statistic, dependent: :destroy
  has_one :player_tackles_statistic, dependent: :destroy

  def self.find_or_initialize_and_update(stat_data, player)
    Rails.logger.info "Updating player statistic: #{stat_data['player']}"
    puts "Stat data: #{stat_data}"

    league_data = stat_data['league']
    season_year = league_data['season']


    league = League.find_or_initialize_by(id: league_data['id'])
    season = Season.find_or_initialize_and_update(league, season_year)

    team_data = stat_data['team']
    team = Team.find_or_initialize_and_update(team_data)

    statistic = PlayerStatistic.find_or_initialize_by(player: player, team: team, season: season)

    if statistic.new_record? || statistic.statistics_updated?(stat_data)
      statistic.last_synced_at = Time.now
      statistic.save!

      PlayerCardsStatistic.find_or_initialize_and_update(stat_data['cards'], statistic)
      PlayerDribblesStatistic.find_or_initialize_and_update(stat_data['dribbles'] , statistic)
      PlayerDuelsStatistic.find_or_initialize_and_update(stat_data['duels'], statistic)
      PlayerFoulsStatistic.find_or_initialize_and_update(stat_data['fouls'], statistic)
      PlayerGamesStatistic.find_or_initialize_and_update(stat_data['games'], statistic)
      PlayerGoalsStatistic.find_or_initialize_and_update(stat_data['goals'], statistic)
      PlayerPassesStatistic.find_or_initialize_and_update(stat_data['passes'], statistic)
      PlayerPenaltyStatistic.find_or_initialize_and_update(stat_data['penalty'], statistic)
      PlayerShotsStatistic.find_or_initialize_and_update(stat_data['shots'], statistic)
      PlayerSubstitutesStatistic.find_or_initialize_and_update(stat_data['substitutes'], statistic)
      PlayerTacklesStatistic.find_or_initialize_and_update(stat_data['tackles'], statistic)
    end
    statistic
  end

  def player_updated?(player_data)

  end
end
