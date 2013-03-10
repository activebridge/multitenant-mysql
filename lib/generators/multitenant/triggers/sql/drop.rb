require_relative '../../views_and_triggers/list/list'
require_relative '../../views_and_triggers/list/sql'

module Multitenant
  module Triggers
    module SQL

      class Drop

        def self.run
          list = Multitenant::List.new
          list.sql = Multitenant::SQL::TRIGGERS
          list.to_a.each do |trigger|
            ActiveRecord::Base.connection.execute("DROP TRIGGER #{trigger};")
            p "==================== Dropped Trigger: #{trigger} =================="
          end
        end

      end

    end
  end
end
