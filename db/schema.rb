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

ActiveRecord::Schema.define(:version => 20111130204721) do

  create_table "address_ranges", :force => true do |t|
    t.integer "geocode_id"
    t.integer "num_start"
    t.integer "num_end"
    t.boolean "is_even"
    t.string  "street"
    t.string  "zipcode"
  end

  add_index "address_ranges", ["geocode_id"], :name => "index_address_ranges_on_geocode_id"

  create_table "assignment_zones", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.spatial  "geometry",   :limit => {:srid=>4326, :type=>"geometry", :geographic=>true}
  end

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.integer  "state_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cities", ["state_id"], :name => "index_cities_on_state_id"

  create_table "coordinates", :force => true do |t|
    t.integer  "assignment_zone_id"
    t.float    "lat"
    t.float    "lng"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coordinates", ["assignment_zone_id"], :name => "index_coordinates_on_assignment_zone_id"

  create_table "geocode_grade_walkzone_schools", :force => true do |t|
    t.boolean "transportation_eligible"
    t.integer "geocode_id"
    t.integer "grade_level_id"
    t.integer "school_id"
  end

  add_index "geocode_grade_walkzone_schools", ["geocode_id"], :name => "index_geocode_grade_walkzone_schools_on_geocode_id"
  add_index "geocode_grade_walkzone_schools", ["grade_level_id"], :name => "index_geocode_grade_walkzone_schools_on_grade_level_id"
  add_index "geocode_grade_walkzone_schools", ["school_id"], :name => "index_geocode_grade_walkzone_schools_on_school_id"

  create_table "geocodes", :force => true do |t|
    t.integer "assignment_zone_id"
  end

  add_index "geocodes", ["assignment_zone_id"], :name => "index_geocodes_on_assignment_zone_id"

  create_table "grade_level_schools", :force => true do |t|
    t.integer  "school_id"
    t.integer  "grade_level_id"
    t.string   "grade_number"
    t.string   "hours"
    t.integer  "open_seats"
    t.integer  "first_choice"
    t.integer  "second_choice"
    t.integer  "third_choice"
    t.integer  "fourth_higher_choice"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mcas_ela_total"
    t.float    "mcas_ela_advanced"
    t.float    "mcas_ela_proficient"
    t.float    "mcas_ela_needsimprovement"
    t.float    "mcas_ela_failing"
    t.integer  "mcas_math_total"
    t.float    "mcas_math_advanced"
    t.float    "mcas_math_proficient"
    t.float    "mcas_math_needsimprovement"
    t.float    "mcas_math_failing"
    t.integer  "mcas_science_total"
    t.float    "mcas_science_advanced"
    t.float    "mcas_science_proficient"
    t.float    "mcas_science_needsimprovement"
    t.float    "mcas_science_failing"
    t.text     "uniform_policy"
  end

  add_index "grade_level_schools", ["grade_level_id"], :name => "index_school_grades_on_grade_level_id"
  add_index "grade_level_schools", ["school_id"], :name => "index_school_grades_on_school_id"

  create_table "grade_levels", :force => true do |t|
    t.string   "number"
    t.float    "walk_zone_radius"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "neighborhoods", :force => true do |t|
    t.integer  "city_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "neighborhoods", ["city_id"], :name => "index_neighborhoods_on_city_id"

  create_table "parcels", :force => true do |t|
    t.spatial  "geometry",   :limit => {:srid=>4326, :type=>"geometry", :geographic=>true}
    t.string   "build_name"
    t.string   "address"
    t.integer  "city_id"
    t.string   "zipcode"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "principals", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "titles"
    t.text     "biography"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "school_levels", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "school_levels_walk_zones", :id => false, :force => true do |t|
    t.integer "walk_zone_id"
    t.integer "school_level_id"
  end

  create_table "school_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "address"
    t.integer  "city_id"
    t.integer  "state_id"
    t.string   "zipcode"
    t.string   "phone"
    t.string   "fax"
    t.string   "website"
    t.integer  "assignment_zone_id"
    t.string   "early_dismissal_time"
    t.integer  "principal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "lat"
    t.float    "lng"
    t.integer  "bpsid"
    t.integer  "org_code"
    t.integer  "teachers_count"
    t.string   "staff_to_student_ratio"
    t.string   "short_name"
    t.integer  "neighborhood_id"
    t.integer  "parcel_id"
    t.integer  "students_count"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "features"
    t.integer  "vertex_id"
    t.boolean  "hidden_gem",             :default => false
    t.boolean  "special_admissions",     :default => false
    t.text     "surround_care_hours"
    t.string   "email"
    t.string   "permalink"
    t.text     "preview_hours"
  end

  add_index "schools", ["assignment_zone_id"], :name => "index_schools_on_assignment_zone_id"
  add_index "schools", ["neighborhood_id"], :name => "index_schools_on_neighborhood_id"
  add_index "schools", ["parcel_id"], :name => "index_schools_on_parcel_id"
  add_index "schools", ["permalink"], :name => "index_schools_on_permalink"
  add_index "schools", ["principal_id"], :name => "index_schools_on_principal_id"

  create_table "schools_walk_zones", :id => false, :force => true do |t|
    t.integer "walk_zone_id"
    t.integer "school_id"
  end

  create_table "states", :force => true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "walk_zones", :force => true do |t|
    t.string   "name"
    t.decimal  "distance"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
