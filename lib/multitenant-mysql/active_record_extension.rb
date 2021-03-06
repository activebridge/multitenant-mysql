ActiveRecord::Base.class_eval do

  class << self

    def acts_as_tenants_bucket
      after_create do
        password = Multitenant::Mysql::DB.configs['password']
        connection = Multitenant::Mysql::DB.connection
        connection.execute "GRANT ALL PRIVILEGES ON *.* TO '#{tenant_name}'@'localhost' IDENTIFIED BY '#{password}' WITH GRANT OPTION;"
        connection.execute "flush privileges;"
      end

      after_destroy do
        connection = Multitenant::Mysql::DB.connection
        connection.execute "DELETE FROM mysql.user where user='#{tenant_name}';"
        connection.execute "flush privileges;"
      end
    end

    def acts_as_tenant
      view_name = model_name.to_s.underscore.pluralize + "_view"
      # check whether the view exists in db
      if ActiveRecord::Base.connection.table_exists? view_name
        self.class_eval do
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

    alias_method :multitenant_mysql_chained_inherited, :inherited

    def inherited(child)
      multitenant_mysql_chained_inherited(child)

      model_name = child.to_s
      if Multitenant::Mysql.configs.models.include? model_name
        child.send :acts_as_tenant
      end

      if Multitenant::Mysql.configs.tenant? child
        child.send :acts_as_tenants_bucket
      end
    end

  end

  def tenant_name
    tenant ||= self.send(Multitenant::Mysql.configs.bucket_field)
  end

end
