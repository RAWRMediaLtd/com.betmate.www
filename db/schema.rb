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

ActiveRecord::Schema[7.1].define(version: 2024_08_10_092256) do
  create_table "countries", force: :cascade do |t|
    t.string "name", null: false
    t.string "code"
    t.string "flag"
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_countries_on_slug", unique: true
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

  create_table "fixture_statuses", force: :cascade do |t|
    t.string "long"
    t.string "short"
    t.integer "elapsed"
    t.integer "fixture_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["country_id"], name: "index_leagues_on_country_id"
  end

  create_table "seasons", force: :cascade do |t|
    t.integer "year"
    t.date "start"
    t.date "end"
    t.boolean "current"
    t.json "coverage"
    t.string "slug"
    t.integer "league_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["league_id"], name: "index_seasons_on_league_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.string "long"
    t.string "short"
    t.integer "elapsed"
    t.integer "fixture_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fixture_id"], name: "index_statuses_on_fixture_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "country"
    t.integer "founded"
    t.boolean "national"
    t.string "logo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  add_foreign_key "fixture_periods", "fixtures"
  add_foreign_key "fixture_scores", "fixtures"
  add_foreign_key "fixture_statuses", "fixtures"
  add_foreign_key "fixtures", "seasons"
  add_foreign_key "fixtures", "teams", column: "away_team_id"
  add_foreign_key "fixtures", "teams", column: "home_team_id"
  add_foreign_key "fixtures", "venues"
  add_foreign_key "leagues", "countries"
  add_foreign_key "seasons", "leagues"
  add_foreign_key "statuses", "fixtures"
end
