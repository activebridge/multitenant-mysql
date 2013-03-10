require_relative '../../views_and_triggers/list/list'
require_relative '../../views_and_triggers/list/sql'

module Multitenant
  module Views
    module SQL
      class Create

        def self.run
          Multitenant::Mysql.models.each do |model_name|
            model = model_name.constantize
            columns = model.column_names.join(', ')
            view_name = model_name.to_s.downcase.pluralize + "_view"

            # stop if view already exists
            return if Multitenant::List.new(Multitenant::SQL::VIEWS).exists?(view_name)

            view_sql = %Q(
        CREATE VIEW #{view_name} AS
        SELECT #{columns}
        FROM #{model.table_name}
        WHERE tenant = SUBSTRING_INDEX(USER(), '@', 1);
            )

            ActiveRecord::Base.connection.execute(view_sql)
            p "==================== Generated View: #{view_name} =================="
          end
        end

      end
    end
  end
end
