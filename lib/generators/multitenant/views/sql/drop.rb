require_relative '../../views_and_triggers/list/list'
require_relative '../../views_and_triggers/list/sql'

module Multitenant
  module Views
    module SQL

      class Drop

        def self.run
          list = Multitenant::List.new
          list.sql = Multitenant::SQL::VIEWS

          list.to_a.each do |view|
            ActiveRecord::Base.connection.execute("DROP VIEW #{view};")
            p "==================== Dropped View: #{view} =================="
          end
        end

      end

    end
  end
end
