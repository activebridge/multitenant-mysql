module Multitenant
  class ViewGenerator

    def self.run
      Multitenant::Mysql.models.each do |model_name|
        model = model_name.constantize
        columns = model.column_names.join(', ')
        view_name = model_name.to_s.downcase.pluralize + "_view"

        # stop if view already exists
        return if ActiveRecord::Base.connection.table_exists?(view_name)

        view_sql = %Q(
        CREATE VIEW #{view_name} AS
        SELECT #{columns}
        FROM #{model.table_name}
        WHERE tenant = SUBSTRING_INDEX(USER(), '@', 1);
        )

        p view_sql

        ActiveRecord::Base.connection.execute(view_sql)
        p "==================== Generated View: #{view_name} =================="
      end
    end

  end
end
