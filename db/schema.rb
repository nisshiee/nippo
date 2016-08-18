# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160713121826) do

  create_table "nippos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "user_id",                                null: false
    t.date     "reported_for",                           null: false
    t.text     "subject",      limit: 65535
    t.text     "body",         limit: 65535
    t.datetime "sent_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "status",                     default: 0, null: false
    t.index ["sent_at"], name: "index_nippos_on_sent_at", using: :btree
    t.index ["user_id", "reported_for"], name: "index_nippos_on_user_id_and_reported_for", unique: true, using: :btree
    t.index ["user_id"], name: "index_nippos_on_user_id", using: :btree
  end

  create_table "oauth_access_grants", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "resource_owner_id",               null: false
    t.integer  "application_id",                  null: false
    t.string   "token",             limit: 190,   null: false
    t.integer  "expires_in",                      null: false
    t.text     "redirect_uri",      limit: 65535, null: false
    t.datetime "created_at",                      null: false
    t.datetime "revoked_at"
    t.string   "scopes"
    t.index ["application_id"], name: "fk_rails_b4b53e07b8", using: :btree
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree
  end

  create_table "oauth_access_tokens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",                  limit: 190,              null: false
    t.string   "refresh_token",          limit: 190
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",                                      null: false
    t.string   "scopes"
    t.string   "previous_refresh_token",             default: "", null: false
    t.index ["application_id"], name: "fk_rails_732cb83ab7", using: :btree
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree
  end

  create_table "oauth_applications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "name",                                    null: false
    t.string   "uid",          limit: 190,                null: false
    t.string   "secret",                                  null: false
    t.text     "redirect_uri", limit: 65535,              null: false
    t.string   "scopes",                     default: "", null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree
  end

  create_table "reactions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "user_id",                null: false
    t.integer  "nippo_id",               null: false
    t.integer  "page_view",  default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["nippo_id"], name: "index_reactions_on_nippo_id", using: :btree
    t.index ["user_id", "nippo_id"], name: "index_reactions_on_user_id_and_nippo_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_reactions_on_user_id", using: :btree
  end

  create_table "templates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "user_id",                  null: false
    t.text     "subject",    limit: 65535
    t.text     "body",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "from_name",  limit: 64
    t.text     "cc",         limit: 65535
    t.index ["user_id"], name: "index_templates_on_user_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "email",              limit: 128,             null: false
    t.string   "provider",           limit: 32,              null: false
    t.string   "uid",                limit: 32,              null: false
    t.string   "name",               limit: 64,              null: false
    t.string   "image",              limit: 128,             null: false
    t.string   "refresh_token",      limit: 128,             null: false
    t.integer  "sign_in_count",                  default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

  create_table "whitelist_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "email",      limit: 128, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["email"], name: "index_whitelist_users_on_email", unique: true, using: :btree
  end

  add_foreign_key "nippos", "users"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "reactions", "nippos"
  add_foreign_key "reactions", "users"
  add_foreign_key "templates", "users"
end
