require_relative '../list'

module Multitenant
  module Triggers
    module SQL

      class Drop
        def self.run
          Multitenant::Triggers::List.triggers.each do |trigger|
            ActiveRecord::Base.connection.execute("DROP TRIGGER #{trigger};")
            p "==================== Dropped Trigger: #{trigger} =================="
          end
        end
      end

    end
  end
end
