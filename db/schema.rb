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

ActiveRecord::Schema.define(:version => 20110927010125) do

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

  create_table "grade_level_hours", :force => true do |t|
    t.integer  "grade_level_id"
    t.integer  "school_id"
    t.string   "grade_level_number"
    t.string   "hours"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "grade_level_hours", ["grade_level_id"], :name => "index_grade_level_hours_on_grade_level_id"
  add_index "grade_level_hours", ["school_id"], :name => "index_grade_level_hours_on_school_id"

  create_table "grade_levels", :force => true do |t|
    t.string   "number"
    t.float    "walk_zone_radius"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "grade_levels_schools", :id => false, :force => true do |t|
    t.integer  "grade_level_id"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mail_clusters", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "neighborhoods", :force => true do |t|
    t.integer  "city_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "school_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.text     "features"
    t.string   "address"
    t.integer  "city_id"
    t.integer  "state_id"
    t.string   "zipcode"
    t.string   "phone"
    t.string   "fax"
    t.string   "website"
    t.integer  "assignment_zone_id"
    t.integer  "mail_cluster_id"
    t.integer  "school_group_id"
    t.string   "hours"
    t.string   "early_dismissal_time"
    t.string   "breakfast"
    t.string   "lunch"
    t.string   "dinner"
    t.integer  "principal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "lat"
    t.float    "lng"
    t.integer  "bpsid"
    t.integer  "org_code"
    t.integer  "teachers_count"
    t.integer  "core_areas_teachers_count"
    t.float    "licensed_teachers_percentage"
    t.float    "qualified_teachers_percentage"
    t.float    "qualified_classes_percentage"
    t.string   "staff_to_student_ratio"
    t.string   "school_level_name"
    t.string   "school_type_name"
    t.string   "short_name"
    t.integer  "neighborhood_id"
    t.integer  "parcel_id"
    t.integer  "students_count"
  end

  add_index "schools", ["assignment_zone_id"], :name => "index_schools_on_assignment_zone_id"
  add_index "schools", ["mail_cluster_id"], :name => "index_schools_on_mail_cluster_id"
  add_index "schools", ["principal_id"], :name => "index_schools_on_principal_id"
  add_index "schools", ["school_group_id"], :name => "index_schools_on_school_group_id"

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

  create_table "walk_zones", :force => true do |t|
    t.string   "name"
    t.decimal  "distance"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
