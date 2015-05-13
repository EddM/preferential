require "spec_helper"

describe Preferential::Generators::MigrationGenerator, type: :generator do
  destination File.expand_path("../../../../tmp", __FILE__)
  arguments %w(preferential)

  before :all do
    prepare_destination
  end

  before :each do
    expect(Preferential::Generators::MigrationGenerator).
      to receive(:next_migration_number) { 123 }

    run_generator
  end

  it "creates a migration" do
    migration_content = <<EOF
class CreatePreferences < ActiveRecord::Migration
  def self.up
    create_table :preferences do |t|
      t.string :name
      t.string :value
      t.integer :owner_id
      t.string :owner_type
      t.timestamps
    end

    add_index :preferences, [:owner_id, :owner_type]
  end

  def self.down
    drop_table :preferences
  end
end
EOF

    assert_file "db/migrate/123_preferential.rb", migration_content
  end
end
