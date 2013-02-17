require 'rails/generators'

require_relative './trigger_generator'
require_relative './view_generator'

require Rails.root.to_s + '/config/multitenant_mysql_conf'

module Multitenant
  class ViewsAndTriggersGenerator < Rails::Generators::Base
    desc "based on specified models will create appropriate mysql views, triggers and migrations"

    def generate_mysql_views
      Multitenant::ViewGenerator.run
    end

    def generate_mysql_triggers
      Multitenant::TriggerGenerator.run
    end
  end
end
