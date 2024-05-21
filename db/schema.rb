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

ActiveRecord::Schema[7.1].define(version: 2024_05_21_043858) do
  create_table "characters", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.text "description"
    t.boolean "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_characters_on_user_id"
  end

  create_table "reports", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "review_id", null: false
    t.string "report"
    t.string "comment"
    t.boolean "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["review_id"], name: "index_reports_on_review_id"
  end

  create_table "reviews", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "story_id", null: false
    t.bigint "user_id", null: false
    t.string "review"
    t.boolean "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["story_id"], name: "index_reviews_on_story_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "stories", charset: "utf8mb3", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id", null: false
    t.string "content"
    t.boolean "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_stories_on_user_id"
  end

  create_table "story_characters", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "story_id", null: false
    t.bigint "character_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_story_characters_on_character_id"
    t.index ["story_id"], name: "index_story_characters_on_story_id"
  end

  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.string "last_name", null: false
    t.string "password_digest"
    t.date "birth_date", null: false
    t.string "mail", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "num_phone"
    t.boolean "state"
    t.boolean "ban"
    t.integer "days_ban"
  end

  add_foreign_key "characters", "users"
  add_foreign_key "reports", "reviews"
  add_foreign_key "reviews", "stories"
  add_foreign_key "reviews", "users"
  add_foreign_key "stories", "users"
  add_foreign_key "story_characters", "characters"
  add_foreign_key "story_characters", "stories"
end
