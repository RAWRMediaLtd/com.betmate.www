# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2024_11_17_160945) do
  create_table "api_usages", force: :cascade do |t|
    t.date "last_reset"
    t.integer "usage"
    t.integer "limit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "countries", force: :cascade do |t|
    t.string "name", null: false
    t.string "code"
    t.string "flag"
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_countries_on_slug", unique: true
  end

  create_table "fixture_events", force: :cascade do |t|
    t.integer "time_elapsed"
    t.boolean "time_extra"
    t.integer "team_id", null: false
    t.integer "player_id", null: false
    t.integer "assist_id"
    t.string "event_type"
    t.string "detail"
    t.string "comments"
    t.integer "fixture_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_synced_at"
    t.index ["assist_id"], name: "index_fixture_events_on_assist_id"
    t.index ["fixture_id"], name: "index_fixture_events_on_fixture_id"
    t.index ["player_id"], name: "index_fixture_events_on_player_id"
    t.index ["team_id"], name: "index_fixture_events_on_team_id"
  end

  create_table "fixture_periods", force: :cascade do |t|
    t.integer "first_half"
    t.integer "second_half"
    t.integer "fixture_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fixture_id"], name: "index_fixture_periods_on_fixture_id"
  end

  create_table "fixture_scores", force: :cascade do |t|
    t.integer "halftime_home"
    t.integer "halftime_away"
    t.integer "fulltime_home"
    t.integer "fulltime_away"
    t.integer "extratime_home"
    t.integer "extratime_away"
    t.integer "penalty_home"
    t.integer "penalty_away"
    t.integer "fixture_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fixture_id"], name: "index_fixture_scores_on_fixture_id"
  end

  create_table "fixture_statistics", force: :cascade do |t|
    t.string "stat_type"
    t.integer "value"
    t.integer "fixture_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "team_id", null: false
    t.boolean "half", default: false
    t.datetime "last_synced_at"
    t.index ["fixture_id"], name: "index_fixture_statistics_on_fixture_id"
    t.index ["team_id"], name: "index_fixture_statistics_on_team_id"
  end

  create_table "fixture_statuses", force: :cascade do |t|
    t.string "long"
    t.string "short"
    t.integer "elapsed"
    t.integer "fixture_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_synced_at"
    t.index ["fixture_id"], name: "index_fixture_statuses_on_fixture_id"
  end

  create_table "fixtures", force: :cascade do |t|
    t.string "referee"
    t.string "timezone"
    t.datetime "date"
    t.integer "timestamp"
    t.integer "venue_id"
    t.integer "home_team_id", null: false
    t.integer "away_team_id", null: false
    t.integer "season_id", null: false
    t.string "round"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.string "winner"
    t.datetime "last_synced_at"
    t.index ["away_team_id"], name: "index_fixtures_on_away_team_id"
    t.index ["home_team_id"], name: "index_fixtures_on_home_team_id"
    t.index ["season_id"], name: "index_fixtures_on_season_id"
    t.index ["venue_id"], name: "index_fixtures_on_venue_id"
  end

  create_table "leagues", force: :cascade do |t|
    t.string "name"
    t.string "league_type"
    t.string "logo"
    t.integer "country_id", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_synced_at"
    t.index ["country_id"], name: "index_leagues_on_country_id"
  end

  create_table "player_cards_statistics", force: :cascade do |t|
    t.integer "yellow"
    t.integer "yellored"
    t.integer "red"
    t.integer "player_statistic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_synced_at"
    t.integer "yellowred"
    t.index ["player_statistic_id"], name: "index_player_cards_statistics_on_player_statistic_id"
  end

  create_table "player_dribbles_statistics", force: :cascade do |t|
    t.integer "attempts"
    t.integer "success"
    t.integer "past"
    t.integer "player_statistic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_synced_at"
    t.index ["player_statistic_id"], name: "index_player_dribbles_statistics_on_player_statistic_id"
  end

  create_table "player_duels_statistics", force: :cascade do |t|
    t.integer "total"
    t.integer "won"
    t.integer "player_statistic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_synced_at"
    t.index ["player_statistic_id"], name: "index_player_duels_statistics_on_player_statistic_id"
  end

  create_table "player_fouls_statistics", force: :cascade do |t|
    t.integer "drawn"
    t.integer "committed"
    t.integer "player_statistic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_synced_at"
    t.index ["player_statistic_id"], name: "index_player_fouls_statistics_on_player_statistic_id"
  end

  create_table "player_games_statistics", force: :cascade do |t|
    t.integer "player_statistic_id", null: false
    t.integer "appearances"
    t.integer "lineups"
    t.integer "minutes"
    t.integer "number"
    t.string "position"
    t.float "rating"
    t.boolean "captain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_synced_at"
    t.index ["player_statistic_id"], name: "index_player_games_statistics_on_player_statistic_id"
  end

  create_table "player_goals_statistics", force: :cascade do |t|
    t.integer "total"
    t.integer "conceded"
    t.integer "assists"
    t.integer "saves"
    t.integer "player_statistic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_synced_at"
    t.index ["player_statistic_id"], name: "index_player_goals_statistics_on_player_statistic_id"
  end

  create_table "player_passes_statistics", force: :cascade do |t|
    t.integer "total"
    t.integer "key"
    t.integer "accuracy"
    t.integer "player_statistic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_synced_at"
    t.index ["player_statistic_id"], name: "index_player_passes_statistics_on_player_statistic_id"
  end

  create_table "player_penalty_statistics", force: :cascade do |t|
    t.integer "won"
    t.integer "committed"
    t.integer "scored"
    t.integer "missed"
    t.integer "saved"
    t.integer "player_statistic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_synced_at"
    t.index ["player_statistic_id"], name: "index_player_penalty_statistics_on_player_statistic_id"
  end

  create_table "player_shots_statistics", force: :cascade do |t|
    t.integer "total"
    t.integer "on"
    t.integer "player_statistic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_synced_at"
    t.index ["player_statistic_id"], name: "index_player_shots_statistics_on_player_statistic_id"
  end

  create_table "player_statistics", force: :cascade do |t|
    t.integer "player_id", null: false
    t.integer "team_id", null: false
    t.integer "season_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_synced_at"
    t.index ["player_id"], name: "index_player_statistics_on_player_id"
    t.index ["season_id"], name: "index_player_statistics_on_season_id"
    t.index ["team_id"], name: "index_player_statistics_on_team_id"
  end

  create_table "player_substitutes_statistics", force: :cascade do |t|
    t.integer "in"
    t.integer "out"
    t.integer "bench"
    t.integer "player_statistic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_synced_at"
    t.index ["player_statistic_id"], name: "index_player_substitutes_statistics_on_player_statistic_id"
  end

  create_table "player_tackles_statistics", force: :cascade do |t|
    t.integer "total"
    t.integer "blocks"
    t.integer "interceptions"
    t.integer "player_statistic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_synced_at"
    t.index ["player_statistic_id"], name: "index_player_tackles_statistics_on_player_statistic_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.string "firstname"
    t.string "lastname"
    t.integer "age"
    t.date "birth_date"
    t.string "birth_place"
    t.string "birth_country"
    t.string "nationality"
    t.string "height"
    t.string "weight"
    t.boolean "injured"
    t.string "photo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_synced_at"
  end

  create_table "seasons", force: :cascade do |t|
    t.integer "year"
    t.date "start_date"
    t.date "end_date"
    t.boolean "current"
    t.json "coverage"
    t.string "slug"
    t.integer "league_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["league_id"], name: "index_seasons_on_league_id"
  end

  create_table "team_seasons", force: :cascade do |t|
    t.integer "team_id", null: false
    t.integer "season_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["season_id"], name: "index_team_seasons_on_season_id"
    t.index ["team_id", "season_id"], name: "index_team_seasons_on_team_and_season", unique: true
    t.index ["team_id"], name: "index_team_seasons_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.integer "country_id"
    t.integer "founded"
    t.boolean "national"
    t.string "logo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_teams_on_country_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "venues", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "city"
    t.integer "capacity"
    t.string "surface"
    t.string "image"
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "fixture_events", "fixtures"
  add_foreign_key "fixture_events", "players"
  add_foreign_key "fixture_events", "players", column: "assist_id"
  add_foreign_key "fixture_events", "teams"
  add_foreign_key "fixture_periods", "fixtures"
  add_foreign_key "fixture_scores", "fixtures"
  add_foreign_key "fixture_statistics", "fixtures"
  add_foreign_key "fixture_statistics", "teams"
  add_foreign_key "fixture_statuses", "fixtures"
  add_foreign_key "fixtures", "seasons"
  add_foreign_key "fixtures", "teams", column: "away_team_id"
  add_foreign_key "fixtures", "teams", column: "home_team_id"
  add_foreign_key "fixtures", "venues"
  add_foreign_key "leagues", "countries"
  add_foreign_key "player_cards_statistics", "player_statistics"
  add_foreign_key "player_dribbles_statistics", "player_statistics"
  add_foreign_key "player_duels_statistics", "player_statistics"
  add_foreign_key "player_fouls_statistics", "player_statistics"
  add_foreign_key "player_games_statistics", "player_statistics"
  add_foreign_key "player_goals_statistics", "player_statistics"
  add_foreign_key "player_passes_statistics", "player_statistics"
  add_foreign_key "player_penalty_statistics", "player_statistics"
  add_foreign_key "player_shots_statistics", "player_statistics"
  add_foreign_key "player_statistics", "players"
  add_foreign_key "player_statistics", "seasons"
  add_foreign_key "player_statistics", "teams"
  add_foreign_key "player_substitutes_statistics", "player_statistics"
  add_foreign_key "player_tackles_statistics", "player_statistics"
  add_foreign_key "seasons", "leagues"
  add_foreign_key "team_seasons", "seasons"
  add_foreign_key "team_seasons", "teams"
  add_foreign_key "teams", "countries"
end
