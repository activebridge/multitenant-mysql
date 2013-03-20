require 'rails/generators'
require_relative './sql/create'

module Multitenant
  module Views
    class Create < Rails::Generators::Base
      desc 'create views for all tenant depended models'

      def generate_mysql_views
        Multitenant::Views::SQL::Create.run
      end
    end
  end
end
