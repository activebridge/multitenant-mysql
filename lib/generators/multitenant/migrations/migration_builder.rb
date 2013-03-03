module Multitenant
  class MigrationBuilder

    class << self

      MIGRATION_NAME = 'add_tenant_column_to_models'

      def run
        return if migration_exists?

        actions = Multitenant::Mysql.models.map { |model_name| 
          model = model_name.constantize
          "add_column :#{model.table_name}, :tenant, :string"
        }

        dest_path = "db/migrate/#{migration_number}_#{MIGRATION_NAME}.rb"
        migration = File.new(dest_path, "w")
        migration.puts(migration_code(actions))
        migration.close

        p "==================== Generated Migration =================="
        p dest_path
      end

      def migration_number
        Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
      end

      def migration_code(actions)
%Q(class AddTenantColumnToModels < ActiveRecord::Migration
  def change
    #{actions.join("\n    ")}
  end
end)
      end

      def migration_exists?
        migrations = Dir.entries("db/migrate")
        migrations.any? { |m| m.include?(MIGRATION_NAME) }
      end
    end

  end
end
