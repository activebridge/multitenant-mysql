require 'rails/generators'
require_relative './sql/drop'
require_relative './sql/create'

module Multitenant
  module Triggers
    class Refresh < Rails::Generators::Base
      desc 'drops all triggers and creates new ones based on configs'

      def refresh_all_triggers
        Multitenant::Triggers::SQL::Drop.run
        Multitenant::Triggers::SQL::Create.run
      end
    end
  end
end
