require_relative '../../views_and_triggers/list/list'
require_relative '../../views_and_triggers/list/sql'

module Multitenant
  module Triggers
    module SQL

      class Create
        def self.run
          Multitenant::Mysql.configs.models.each do |model_name|
            model = model_name.constantize
            trigger_name = model.original_table_name + '_tenant_trigger'

            return if Multitenant::List.new(Multitenant::SQL::TRIGGERS).exists?(trigger_name)

            trigger_sql = %Q(
        CREATE TRIGGER #{trigger_name}
        BEFORE INSERT ON #{model.original_table_name}
        FOR EACH ROW
        SET new.tenant = SUBSTRING_INDEX(USER(), '@', 1);
            )

            p trigger_sql
            ActiveRecord::Base.connection.execute(trigger_sql)
            p "==================== Generated Trigger: #{trigger_name} =================="
          end
        end

      end

    end
  end
end
