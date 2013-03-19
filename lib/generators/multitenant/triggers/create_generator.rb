require 'rails/generators'
require_relative './sql/create'

module Multitenant
  module Triggers
    class Create < Rails::Generators::Base
      desc 'create triggers for all tenant depended models'

      def generate_mysql_triggers
        Multitenant::Triggers::SQL::Create.run
      end
    end
  end
end
