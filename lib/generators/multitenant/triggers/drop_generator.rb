require 'rails/generators'
require_relative './sql/drop'

module Multitenant
  module Triggers
    class Drop < Rails::Generators::Base
      desc 'drops all triggers in db'

      def drop_all_triggers
        Multitenant::Triggers::SQL::Drop.run
      end
    end
  end
end
