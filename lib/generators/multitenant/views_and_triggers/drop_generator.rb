require 'rails/generators'

require_relative '../views/sql/drop'
require_relative '../triggers/sql/drop'

module Multitenant
  module ViewsAndTriggers
    class DropGenerator < Rails::Generators::Base
      desc "drops all views and triggers"

      def generate_mysql_views
        Multitenant::Views::SQL::Drop.run
      end

      def generate_mysql_triggers
        Multitenant::Triggers::SQL::Drop.run
      end
    end
  end
end
