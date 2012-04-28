# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120428045602) do

  create_table "assignments", :force => true do |t|
    t.integer  "student_id"
    t.integer  "assistant_id"
    t.integer  "substitute_id"
    t.integer  "schedule_item_id"
    t.date     "week_of",                        :null => false
    t.string   "type",             :limit => 20
    t.string   "state",            :limit => 20
    t.text     "notes"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "lesson_id"
    t.string   "lesson_status"
    t.integer  "lesson_next"
    t.text     "lesson_notes"
    t.integer  "setting_id"
  end

  add_index "assignments", ["assistant_id"], :name => "index_assignments_on_assistant_id"
  add_index "assignments", ["student_id"], :name => "index_assignments_on_student_id"

  create_table "congregations", :force => true do |t|
    t.string   "name",              :limit => 150,                :null => false
    t.integer  "number_of_schools",                :default => 1, :null => false
    t.integer  "language_id"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.integer  "meeting_day"
  end

  add_index "congregations", ["name"], :name => "index_congregations_on_name"

  create_table "congregations_users", :id => false, :force => true do |t|
    t.integer "congregation_id", :null => false
    t.integer "user_id",         :null => false
  end

  add_index "congregations_users", ["congregation_id", "user_id"], :name => "index_congregations_users_on_congregation_and_user"
  add_index "congregations_users", ["user_id", "congregation_id"], :name => "index_congregations_users_on_user_and_congregation"

  create_table "families", :force => true do |t|
    t.string   "name",            :limit => 100, :null => false
    t.integer  "congregation_id",                :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "families", ["congregation_id", "name"], :name => "index_families_on_congregation_id_and_name"

  create_table "languages", :force => true do |t|
    t.string   "name",         :limit => 50, :null => false
    t.string   "display_name", :limit => 50
    t.string   "code",         :limit => 10
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "lesson_histories", :force => true do |t|
    t.integer  "lesson_id",       :null => false
    t.date     "assignment_date", :null => false
    t.text     "notes"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "lesson_histories", ["lesson_id"], :name => "index_lesson_histories_on_lesson_id"

  create_table "lesson_sources", :force => true do |t|
    t.integer  "language_id"
    t.integer  "chapter",                                                 :null => false
    t.string   "description",           :limit => 150, :default => "",    :null => false
    t.integer  "page_number"
    t.boolean  "use_for_reading",                      :default => false, :null => false
    t.boolean  "use_for_demonstration",                :default => false, :null => false
    t.boolean  "use_for_discourse",                    :default => false, :null => false
    t.text     "notes"
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
  end

  add_index "lesson_sources", ["language_id", "chapter"], :name => "index_lesson_sources_on_language_id_and_chapter"

  create_table "lessons", :force => true do |t|
    t.integer  "student_id",                             :null => false
    t.integer  "lesson_source_id",                       :null => false
    t.date     "date_started"
    t.date     "date_completed"
    t.boolean  "exercises_completed", :default => false, :null => false
    t.text     "notes"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "lessons", ["student_id"], :name => "index_lessons_on_student_id"

  create_table "schedule_items", :force => true do |t|
    t.string   "title",             :limit => 100
    t.string   "source",            :limit => 50
    t.boolean  "for_brother_only",                 :default => false, :null => false
    t.boolean  "for_adult_only",                   :default => false, :null => false
    t.boolean  "for_advanced_only",                :default => false, :null => false
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
  end

  create_table "schedules", :force => true do |t|
    t.date     "week_of",                                :null => false
    t.boolean  "has_review",          :default => false, :null => false
    t.integer  "language_id",                            :null => false
    t.integer  "bible_highlights_id"
    t.integer  "talk_no1_id"
    t.integer  "talk_no2_id"
    t.integer  "talk_no3_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "schedules", ["language_id", "week_of"], :name => "index_schedules_language_and_week_of", :unique => true

  create_table "school_sessions", :force => true do |t|
    t.date     "week_of",                                              :null => false
    t.integer  "bible_highlights_id"
    t.integer  "reader_id"
    t.integer  "congregation_id"
    t.string   "state",               :limit => 20
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.boolean  "has_review",                        :default => false
  end

  add_index "school_sessions", ["week_of", "congregation_id"], :name => "index_school_sessions_on_week_of_and_congregation_id"

  create_table "schools", :force => true do |t|
    t.integer  "school_session_id"
    t.integer  "talk_no1_id"
    t.integer  "talk_no2_id"
    t.integer  "talk_no3_id"
    t.integer  "position"
    t.string   "state",             :limit => 20
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "schools", ["school_session_id", "position"], :name => "index_schools_on_school_session_id_and_position"
  add_index "schools", ["school_session_id"], :name => "index_schools_on_school_session_id"

  create_table "setting_sources", :force => true do |t|
    t.integer  "language_id"
    t.integer  "number",                                     :null => false
    t.string   "description", :limit => 200, :default => "", :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "setting_sources", ["language_id", "number"], :name => "index_setting_sources_on_language_id_and_number"

  create_table "settings", :force => true do |t|
    t.integer  "setting_source_id", :null => false
    t.integer  "student_id",        :null => false
    t.date     "date_used"
    t.text     "notes"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "special_dates", :force => true do |t|
    t.date     "week_of",                                              :null => false
    t.integer  "congregation_id"
    t.string   "event",               :limit => 50,                    :null => false
    t.string   "description",         :limit => 50
    t.boolean  "is_cancelled",                      :default => true,  :null => false
    t.boolean  "is_review_postponed",               :default => false, :null => false
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
  end

  add_index "special_dates", ["week_of", "congregation_id"], :name => "index_special_dates_on_week_of_and_congregation_id", :unique => true

  create_table "students", :force => true do |t|
    t.string   "first_name",              :limit => 50
    t.string   "last_name",               :limit => 50
    t.string   "display_name",            :limit => 100
    t.string   "telephone",               :limit => 15
    t.string   "email",                   :limit => 150
    t.text     "notes"
    t.string   "type",                    :limit => 20
    t.boolean  "is_active",                              :default => true,  :null => false
    t.boolean  "use_for_advanced",                       :default => false, :null => false
    t.boolean  "use_for_adult",                          :default => true,  :null => false
    t.boolean  "use_in_main_school",                     :default => true,  :null => false
    t.boolean  "use_in_secondary_school",                :default => true,  :null => false
    t.boolean  "use_for_reader",                         :default => false, :null => false
    t.boolean  "use_for_bh",                             :default => false, :null => false
    t.boolean  "use_for_no1",                            :default => false, :null => false
    t.boolean  "use_for_no2",                            :default => false, :null => false
    t.boolean  "use_for_no3",                            :default => false, :null => false
    t.boolean  "use_for_assistant",                      :default => false, :null => false
    t.integer  "congregation_id"
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
    t.integer  "family_id"
    t.string   "middle_name",             :limit => 50
    t.integer  "next_lesson"
  end

  add_index "students", ["last_name"], :name => "index_students_on_last_name"

  create_table "unavailable_dates", :force => true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.string   "reason"
    t.integer  "student_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "unavailable_dates", ["end_date"], :name => "index_unavailable_dates_on_end_date"
  add_index "unavailable_dates", ["start_date", "end_date"], :name => "index_unavailable_dates_on_start_date_and_end_date"
  add_index "unavailable_dates", ["start_date"], :name => "index_unavailable_dates_on_start_date"
  add_index "unavailable_dates", ["student_id"], :name => "index_unavailable_dates_on_student_id"

  create_table "users", :force => true do |t|
    t.string   "email",                   :default => "",    :null => false
    t.string   "encrypted_password",      :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",           :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "authentication_token"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "name"
    t.string   "cached_slug"
    t.datetime "deleted_at"
    t.integer  "default_congregation_id"
    t.boolean  "admin",                   :default => false
    t.string   "unconfirmed_email"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
