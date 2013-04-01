module Multitenant
  module Mysql
    class DB
      class << self
        def configs
          @configs ||= Rails.configuration.database_configuration[Rails.env]
        end

        def configs=(configs)
          @configs = configs
        end

        def establish_connection_for tenant_name
          config = configs
          config['username'] = tenant_name.blank? ? 'root' : tenant_name
          ActiveRecord::Base.establish_connection(config)
        end

        def connection
          ActiveRecord::Base.connection
        end
      end
    end
  end
end
