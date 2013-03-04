class ActiveRecord::Base
  def self.acts_as_tenant
    after_create do
      config = Rails.configuration.database_configuration
      password = config[Rails.env]["password"]
      ActiveRecord::Base.connection.execute "GRANT ALL PRIVILEGES ON *.* TO '#{self.name}'@'localhost' IDENTIFIED BY '#{password}' WITH GRANT OPTION;"
      ActiveRecord::Base.connection.execute "flush privileges;"
    end
  end

  def self.inherited(child)
    return unless FileTest.exist?(Multitenant::Mysql::ConfFile.full_path) # do nothing if no config file provided
    require Multitenant::Mysql::ConfFile.path

    model_name = child.to_s
    if Multitenant::Mysql.models.include? model_name
      view_name = model_name.to_s.downcase.pluralize + "_view"

      # check whether the view exists in db
      if ActiveRecord::Base.connection.table_exists? view_name
        child.class_eval do
          cattr_accessor :original_table_name

          self.original_table_name = self.table_name
          self.table_name = view_name
          self.primary_key = :id

          def self.new(*args)
            object = super(*args)
            object.id = nil # workaround for https://github.com/rails/rails/issues/5982
            object
          end
        end
      end
    end

    if Multitenant::Mysql.tenant == child
      child.send :acts_as_tenant
    end
  end
end
