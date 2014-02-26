require_relative '../../views_and_triggers/list/list'
require_relative '../../views_and_triggers/list/sql'

module Multitenant
  module Views
    module SQL
      class Create

        def self.run
          Multitenant::Mysql.configs.models.each do |model_name|
            model = model_name.constantize
            columns = model.column_names.collect{|name| "`#{name}`"}.join(', ')
            view_name = model_name.to_s.underscore.pluralize + "_view"

            # stop if view already exists
            return if Multitenant::List.new(Multitenant::SQL::VIEWS).exists?(view_name)

            view_sql = %Q(
        CREATE VIEW #{view_name} AS
        SELECT #{columns}
        FROM #{model.table_name}
            )

            if Multitenant::Mysql.configs.bucket.has_super_tenant_identifier?
              #puts "YES IT HAS SUPER TENANT"
              view_sql += "WHERE IF(SUBSTRING_INDEX(USER(), '@', 1) = '#{Multitenant::Mysql.configs.bucket.super_tenant_identifier}', tenant, SUBSTRING_INDEX(USER(), '@', 1)) = tenant"
            else
              #puts "NO IT DOESNT HAVE SUPER TENANT"
              view_sql += 'WHERE tenant = SUBSTRING_INDEX(USER(), \'@\', 1);'
            end

            #puts view_sql
            ActiveRecord::Base.connection.execute(view_sql)
            p "==================== Generated View: #{view_name} =================="
          end
        end

      end
    end
  end
end
