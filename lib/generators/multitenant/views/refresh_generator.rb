require 'rails/generators'
require_relative './sql/drop'
require_relative './sql/create'

module Multitenant
  module Views
    class Refresh < Rails::Generators::Base
      desc 'drops all views and creates new ones based on configs'

      def refresh_all_views
        Multitenant::Views::SQL::Drop.run
        Multitenant::Views::SQL::Create.run
      end
    end
  end
end
