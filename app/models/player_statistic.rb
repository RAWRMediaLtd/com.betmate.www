class PlayerStatistic < ApplicationRecord
  belongs_to :player
  belongs_to :team
  belongs_to :season

  has_one :player_cards_statistic, dependant: :destroy
  has_one :player_dribbles_statistic, dependant: :destroy
  has_one :player_duels_statistic, dependant: :destroy
  has_one :player_fouls_statistic, dependant: :destroy
  has_one :player_games_statistic, dependant: :destroy
  has_one :player_goals_statistic, dependant: :destroy
  has_one :player_passes_statistic, dependant: :destroy
  has_one :player_penalty_statistic, dependant: :destroy
  has_one :player_shots_statistic, dependant: :destroy
  has_one :player_substitutes_statistic, dependant: :destroy
  has_one :player_tackles_statistic, dependant: :destroy

  def self.find_or_initialize_and_update(stat_data, player)

    country = Country.find_or_initialize_by(name: stat_data['league']['country'])

    league_data = stat_data['league']
    league = League.find_or_initialize_and_update(league_data, stat_data['league']['country'])

    season = Season.find_or_initialize_and_update(year: stat_data['league']['season'], country)
    team = Team.find_or_initialize_and_update(id: stat_data['team']['id'])

    statistic = PlayerStatistic.find_or_initialize_and_update(player: player, team: team, season: season)

    if statistic.new_record? || statistic.statistics_updated?(stat_data)
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
end
