require 'rails/generators'
require_relative './sql/drop'

module Multitenant
  module Views
    class Drop < Rails::Generators::Base
      desc 'drop all views in db'

      def drop_all_views
        Multitenant::Views::SQL::Drop.run
      end
    end
  end
end
