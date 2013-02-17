module Multitenant
  class TriggerGenerator

    class << self
      def run
        Multitenant::Mysql.models.each do |model_name|
          model = model_name.constantize
          trigger_name = model.original_table_name + '_tenant_trigger'

          return if trigger_exists?(trigger_name)

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

      def trigger_exists?(trigger_name)
        config = Rails.configuration.database_configuration[Rails.env]
        db_name = config['database']

        find_trigger_sql = "SELECT trigger_name FROM information_schema.TRIGGERS where trigger_schema = '#{db_name}';"
        result = ActiveRecord::Base.connection.execute(find_trigger_sql).to_a.flatten

        result.include?(trigger_name)
      end
    end
  end

end
