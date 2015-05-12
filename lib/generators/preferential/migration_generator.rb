require "rails/generators/active_record"

module Preferential
  module Generators
    class MigrationGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def create_migration_file
        migration_template "migration.rb", "db/migrate/preferential.rb"
      end
    end
  end
end
