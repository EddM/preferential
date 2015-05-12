ActiveRecord::Schema.define(version: 1) do
  create_table :users do |t|
    t.string :username
    t.timestamps
  end

  create_table :widgets do |t|
    t.string :description
  end
end

require File.expand_path(File.dirname(__FILE__) + '/../lib/generators/preferential/templates/migration') 
CreatePreferences.up
