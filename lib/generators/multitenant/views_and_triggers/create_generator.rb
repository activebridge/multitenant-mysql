require 'rails/generators'

require_relative '../views/sql/create'
require_relative '../triggers/sql/create'

require Rails.root.to_s + '/config/multitenant_mysql_conf'

module Multitenant
  module ViewsAndTriggers
    class CreateGenerator < Rails::Generators::Base
      desc "based on specified models creates appropriate mysql views and triggers"

      def generate_mysql_views
        Multitenant::Views::SQL::Create.run
      end

      def generate_mysql_triggers
        Multitenant::Triggers::SQL::Create.run
      end
    end
  end
end
