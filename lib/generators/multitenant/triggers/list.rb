module Multitenant
  module Triggers

    class List
      class << self

        def exists?(name)
          triggers.include?(name)
        end

        def triggers
          ActiveRecord::Base.connection.execute(list_sql).to_a.flatten
        end

        def list_sql
          db_name = Multitenant::Mysql::DB.configs['database']
          "SELECT trigger_name FROM information_schema.TRIGGERS where trigger_schema = '#{db_name}';"
        end

      end
    end

  end
end
