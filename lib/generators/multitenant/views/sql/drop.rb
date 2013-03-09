module Multitenant
  module Views
    module SQL
      class Drop

        class << self
          def run
            views_list.each do |view|
              ActiveRecord::Base.connection.execute("drop view #{view};")
              p "==================== Dropped View: #{view} =================="
            end
          end

          private

          def views_list
            list = ActiveRecord::Base.connection.execute(views_list_sql)
            list.to_a.flatten
          end

          def views_list_sql
            database = Multitenant::Mysql::DB.configs['database']
            "SELECT TABLE_NAME FROM information_schema.`TABLES` WHERE TABLE_TYPE LIKE 'VIEW' AND TABLE_SCHEMA LIKE '#{database}';"
          end
        end

      end
    end
  end
end
