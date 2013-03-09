require_relative '../list'

module Multitenant
  module Triggers
    module SQL

      class Create

        class << self
          def run
            Multitenant::Mysql.models.each do |model_name|
              model = model_name.constantize
              trigger_name = model.original_table_name + '_tenant_trigger'

              return if Multitenant::Triggers::List.exists?(trigger_name)

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
end
