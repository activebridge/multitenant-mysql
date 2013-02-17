require 'rails/generators'

require_relative './migration_builder'
require Rails.root.to_s + '/config/multitenant_mysql_conf'

module Multitenant
  class MigrationsGenerator < Rails::Generators::Base
    desc 'create migration to add tenant column to listed models'

    def generate_migration
      Multitenant::MigrationBuilder.run
    end
  end
end
