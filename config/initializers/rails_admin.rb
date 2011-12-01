#         ooooooooo.              o8o  oooo                 .o.             .o8                     o8o              
#         `888   `Y88.            `"'  `888                .888.           "888                     `"'              
#          888   .d88'  .oooo.   oooo   888   .oooo.o     .8"888.      .oooo888  ooo. .oo.  .oo.   oooo  ooo. .oo.   
#          888ooo88P'  `P  )88b  `888   888  d88(  "8    .8' `888.    d88' `888  `888P"Y88bP"Y88b  `888  `888P"Y88b  
#          888`88b.     .oP"888   888   888  `"Y88b.    .88ooo8888.   888   888   888   888   888   888   888   888  
#          888  `88b.  d8(  888   888   888  o.  )88b  .8'     `888.  888   888   888   888   888   888   888   888  
#         o888o  o888o `Y888""8o o888o o888o 8""888P' o88o     o8888o `Y8bod88P" o888o o888o o888o o888o o888o o888o 

# RailsAdmin config file. Generated on November 30, 2011 12:35
# See github.com/sferik/rails_admin for more informations

RailsAdmin.config do |config|
  
  config.current_user_method { current_user } # auto-generated
  
  config.main_app_name { ['DiscoverBPS', 'Admin'] }
  
  #  ==> Authentication (before_filter)
  # This is run inside the controller instance so you can setup any authentication you need to.
  # By default, the authentication will run via warden if available.
  # and will run on the default user scope.
  # If you use devise, this will authenticate the same as authenticate_user!
  # Example Devise admin
  # RailsAdmin.config do |config|
  #   config.authenticate_with do
  #     authenticate_admin!
  #   end
  # end
  # Example Custom Warden
  # RailsAdmin.config do |config|
  #   config.authenticate_with do
  #     warden.authenticate! :scope => :paranoid
  #   end
  # end
  
  #  ==> Authorization
  # Use cancan https://github.com/ryanb/cancan for authorization:
  # config.authorize_with :cancan
  
  # Or use simple custom authorization rule:
  # config.authorize_with do
  #   redirect_to root_path unless warden.user.is_admin?
  # end
  
  # Use a specific role for ActiveModel's :attr_acessible :attr_protected
  # Default is :default
  # current_user is accessible in the block if you want to make it user specific.
  # config.attr_accessible_role { :default }
    
  #  ==> Global show view settings
  # Display empty fields in show views
  # config.compact_show_view = false
  
  #  ==> Global list view settings
  # Number of default rows per-page:
  # config.default_items_per_page = 50
  
  #  ==> Included models
  # Add all excluded models here:
  # config.excluded_models << [AddressRange, AssignmentZone, City, Geocode, GeocodeGradeWalkzoneSchool, GradeLevel, GradeLevelSchool, Neighborhood, Parcel, Principal, School, State, User]
  
  # Add models here if you want to go 'whitelist mode':
  # config.included_models << [AddressRange, AssignmentZone, City, Geocode, GeocodeGradeWalkzoneSchool, GradeLevel, GradeLevelSchool, Neighborhood, Parcel, Principal, School, State, User]
  
  # Application wide tried label methods for models' instances
  # config.label_methods << [:description] # Default is [:name, :title]
  
  #  ==> Global models configuration
  # config.models do
  #   # Configuration here will affect all included models in all scopes, handle with care!
  #   
  #   list do
  #     # Configuration here will affect all included models in list sections (same for show, export, edit, update, create)
  #     
  #     fields :name, :other_name do
  #       # Configuration here will affect all fields named [:name, :other_name], in the list section, for all included models
  #     end
  #     
  #     fields_of_type :date do
  #       # Configuration here will affect all date fields, in the list section, for all included models. See README for a comprehensive type list.
  #     end
  #   end
  # end
  #
  #  ==> Model specific configuration
  # Keep in mind that *all* configuration blocks are optional. 
  # RailsAdmin will try his best to provide the best defaults for each section, for each field! 
  # Try to override as few things as possible, in the most generic way. Try to avoid setting labels for models and attributes, use ActiveRecord I18n API instead. 
  # Less code is better code!
  # config.model MyModel do
  #   # Here goes your cross-section field configuration for ModelName.
  #   object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #   label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #   label_plural 'My models'      # Same, plural
  #   weight -1                     # Navigation priority. Bigger is higher.
  #   parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #   navigation_label              # Sets dropdown entry's name in navigation. Only for parents!
  #   # Section specific configuration:
  #   list do
  #     filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #     items_per_page 100    # Override default_items_per_page
  #     sort_by :id           # Sort column (default is primary key)
  #     sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     # Here goes the fields configuration for the list view
  #   end
  #   show do
  #     # Here goes the fields configuration for the show view
  #   end
  #   export do
  #     # Here goes the fields configuration for the export view (CSV, yaml, XML)
  #   end
  #   edit do
  #     # Here goes the fields configuration for the edit view (for create and update view)
  #   end
  #   create do
  #     # Here goes the fields configuration for the create view, overriding edit section settings
  #   end
  #   update do
  #     # Here goes the fields configuration for the update view, overriding edit section settings
  #   end
  # end
  
# fields configuration is described in the Readme, if you have other question, ask us on the mailing-list! 

#  ==> Your models configuration, to help you get started!

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  # config.model AddressRange do
  #   # Found associations: 
  #   field :geocode, :belongs_to_association
  #   # Found columns:
  #   field :id, :integer
  #   field :geocode_id, :integer        # Hidden
  #   field :num_start, :integer
  #   field :num_end, :integer
  #   field :is_even, :boolean
  #   field :street, :string
  #   field :zipcode, :string
  #   # Sections: 
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  #  end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  # config.model AssignmentZone do
  #   # Found associations: 
  #   field :schools, :has_many_association
  #   # Found columns:
  #   field :id, :integer
  #   field :name, :string
  #   field :created_at, :datetime
  #   field :updated_at, :datetime
  #   field :geometry, :text
  #   # Sections: 
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  #  end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  # config.model City do
  #   # Found associations: 
  #   field :state, :belongs_to_association
  #   field :schools, :has_many_association
  #   field :neighborhoods, :has_many_association
  #   # Found columns:
  #   field :id, :integer
  #   field :name, :string
  #   field :state_id, :integer        # Hidden
  #   field :created_at, :datetime
  #   field :updated_at, :datetime
  #   # Sections: 
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  #  end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  # config.model Geocode do
  #   # Found associations: 
  #   field :address_ranges, :has_many_association
  #   field :geocode_grade_walkzone_schools, :has_many_association
  #   field :assignment_zone, :belongs_to_association
  #   # Found columns:
  #   field :id, :integer
  #   field :assignment_zone_id, :integer        # Hidden
  #   # Sections: 
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  #  end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  # config.model GeocodeGradeWalkzoneSchool do
  #   # Found associations: 
  #   field :geocode, :belongs_to_association
  #   field :grade_level, :belongs_to_association
  #   field :school, :belongs_to_association
  #   # Found columns:
  #   field :id, :integer
  #   field :transportation_eligible, :boolean
  #   field :geocode_id, :integer        # Hidden
  #   field :grade_level_id, :integer        # Hidden
  #   field :school_id, :integer        # Hidden
  #   # Sections: 
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  #  end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  config.model GradeLevel do
    object_label_method do
      :grade_level_label
    end
    field :id, :integer
    field :number, :string
    field :name, :string
    field :walk_zone_radius, :float
    # Found associations: 
    field :grade_level_schools, :has_many_association
    field :schools, :has_many_association
    # Found columns:
    # field :created_at, :datetime
    # field :updated_at, :datetime
    # Sections: 
    list do; end
    export do; end
    show do; end
    edit do; end
    create do; end
    update do; end
   end
   
   def grade_level_label
     "Grade #{self.number}"
   end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  # config.model GradeLevelSchool do
  #   # Found associations: 
  #   field :school, :belongs_to_association
  #   field :grade_level, :belongs_to_association
  #   # Found columns:
  #   field :id, :integer
  #   field :school_id, :integer        # Hidden
  #   field :grade_level_id, :integer        # Hidden
  #   field :grade_number, :string
  #   field :hours, :string
  #   field :open_seats, :integer
  #   field :first_choice, :integer
  #   field :second_choice, :integer
  #   field :third_choice, :integer
  #   field :fourth_higher_choice, :integer
  #   field :created_at, :datetime
  #   field :updated_at, :datetime
  #   field :mcas_ela_total, :integer
  #   field :mcas_ela_advanced, :float
  #   field :mcas_ela_proficient, :float
  #   field :mcas_ela_needsimprovement, :float
  #   field :mcas_ela_failing, :float
  #   field :mcas_math_total, :integer
  #   field :mcas_math_advanced, :float
  #   field :mcas_math_proficient, :float
  #   field :mcas_math_needsimprovement, :float
  #   field :mcas_math_failing, :float
  #   field :mcas_science_total, :integer
  #   field :mcas_science_advanced, :float
  #   field :mcas_science_proficient, :float
  #   field :mcas_science_needsimprovement, :float
  #   field :mcas_science_failing, :float
  #   field :uniform_policy, :text
  #   # Sections: 
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  #  end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  # config.model Neighborhood do
  #   # Found associations: 
  #   field :city, :belongs_to_association
  #   field :schools, :has_many_association
  #   # Found columns:
  #   field :id, :integer
  #   field :city_id, :integer        # Hidden
  #   field :name, :string
  #   field :created_at, :datetime
  #   field :updated_at, :datetime
  #   # Sections: 
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  #  end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  config.model Parcel do
    object_label_method do
      :parcel_label
    end
    # Found columns:
    field :id, :integer
    field :address, :string
    field :geometry, :text
    field :build_name, :string
    field :city_id, :integer
    field :zipcode, :string
    # Found associations: 
    field :schools, :has_many_association
    # field :created_at, :datetime
    # field :updated_at, :datetime
    # Sections: 
    list do; end
    export do; end
    show do; end
    edit do; end
    create do; end
    update do; end
   end
   
   def parcel_label
    "#{self.build_name} - #{self.address}"
   end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  # config.model Principal do
  #   # Found associations: 
  #   field :schools, :has_many_association
  #   # Found columns:
  #   field :id, :integer
  #   field :first_name, :string
  #   field :last_name, :string
  #   field :titles, :string
  #   field :biography, :text
  #   field :created_at, :datetime
  #   field :updated_at, :datetime
  #   # Sections: 
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  #  end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  config.model School do
    # Found columns:
    field :id, :integer
    field :bpsid, :integer
    field :org_code, :integer
    field :name, :string
    field :hidden_gem, :boolean
    field :special_admissions, :boolean
    field :short_name, :string
    field :permalink, :string
    field :description, :text
    field :features, :text
    field :address, :string
    field :city, :belongs_to_association
    field :neighborhood, :belongs_to_association
    field :state, :belongs_to_association
    field :zipcode, :string
    field :assignment_zone, :belongs_to_association
    field :parcel, :belongs_to_association
    field :phone, :string
    field :fax, :string
    field :website, :string
    field :email, :string
    field :early_dismissal_time, :string
    field :surround_care_hours, :text
    field :preview_hours, :text
    field :lat, :float
    field :lng, :float
    field :teachers_count, :integer
    field :staff_to_student_ratio, :string
    field :image, :paperclip_file
    
    # field :grade_level_schools, :has_many_association #Hidden
    field :grade_levels, :has_many_association
    # field :principal, :belongs_to_association #Hidden
    field :geocode_grade_walkzone_schools, :has_many_association

    # field :created_at, :datetime
    # field :updated_at, :datetime

    # Sections: 
    list do; end
    export do; end
    show do; end
    edit do; end
    create do; end
    update do; end
   end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  # config.model State do
  #   # Found associations: 
  #   field :schools, :has_many_association
  #   field :cities, :has_many_association
  #   # Found columns:
  #   field :id, :integer
  #   field :name, :string
  #   field :abbreviation, :string
  #   field :created_at, :datetime
  #   field :updated_at, :datetime
  #   # Sections: 
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  #  end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  # config.model User do
  #   # Found associations: 
  #   # Found columns:
  #   field :id, :integer
  #   field :email, :string
  #   field :password, :password
  #   field :password_confirmation, :password
  #   field :reset_password_token, :string        # Hidden
  #   field :reset_password_sent_at, :datetime
  #   field :remember_created_at, :datetime
  #   field :sign_in_count, :integer
  #   field :current_sign_in_at, :datetime
  #   field :last_sign_in_at, :datetime
  #   field :current_sign_in_ip, :string
  #   field :last_sign_in_ip, :string
  #   field :created_at, :datetime
  #   field :updated_at, :datetime
  #   # Sections: 
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  #  end

end

# You made it this far? You're looking for something that doesn't exist! Add it to RailsAdmin and send us a Pull Request!