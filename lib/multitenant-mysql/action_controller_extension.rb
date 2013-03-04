require_relative './connection_switcher'

class ActionController::Base
  def self.set_current_tenant(tenant_method)
    require Multitenant::Mysql::ConfFile.path

    raise "you should provide tenant method" unless tenant_method

    @@tenant_method = tenant_method

    before_filter :establish_tenant_connection

    def establish_tenant_connection
      Multitenant::Mysql::ConnectionSwitcher.new(self, @@tenant_method).execute
    end
  end

  def self.set_current_tenant_by_subdomain
    require Multitenant::Mysql::ConfFile.path

    before_filter :establish_tenant_connection_by_subdomain

    def establish_tenant_connection_by_subdomain
      tenant_name = request.subdomain
      Multitenant::Mysql::ConnectionSwitcher.set_tenant(tenant_name)
    end
  end
end
