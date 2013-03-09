require 'rails/generators'

require_relative '../views/sql/create'
require_relative '../views/sql/drop'
require_relative '../triggers/sql/create'
require_relative '../triggers/sql/drop'

require Rails.root.to_s + '/config/multitenant_mysql_conf'

module Multitenant
  module ViewsAndTriggers
    class RefreshGenerator < Rails::Generators::Base
      desc "drops all views and triggers and creates new ones based on configs"

      def generate_mysql_views
        Multitenant::Views::SQL::Drop.run
        Multitenant::Views::SQL::Create.run
      end

      def generate_mysql_triggers
        Multitenant::Triggers::SQL::Drop.run
        Multitenant::Triggers::SQL::Create.run
      end
    end
  end
end
