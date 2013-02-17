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
end
