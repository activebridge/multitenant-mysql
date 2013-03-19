require 'rails/generators'

require_relative './migration_builder'

module Multitenant
  class MigrationsGenerator < Rails::Generators::Base
    desc 'create migration to add tenant column to listed models'

    def generate_migration
      Multitenant::MigrationBuilder.run
    end
  end
end
