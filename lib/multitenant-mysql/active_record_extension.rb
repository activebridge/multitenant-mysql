class ActiveRecord::Base
  def self.acts_as_tenant
    after_create do
      config = Rails.configuration.database_configuration
      password = config[Rails.env]["password"]
      ActiveRecord::Base.connection.execute "GRANT ALL PRIVILEGES ON *.* TO '#{self.name}'@'localhost' IDENTIFIED BY '#{password}' WITH GRANT OPTION;"
      ActiveRecord::Base.connection.execute "flush privileges;"
    end
  end
end
