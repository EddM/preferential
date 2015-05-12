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
