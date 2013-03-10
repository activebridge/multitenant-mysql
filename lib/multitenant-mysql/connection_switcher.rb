require_relative './db'

module Multitenant
  module Mysql
    class NoTenantRegistratedError < StandardError; end;

    class Tenant
      def self.exists? tenant_name
        return true if tenant_name.blank?
        if Multitenant::Mysql.tenant.where(Multitenant::Mysql.tenant_name_attr => tenant_name).blank?
          raise Multitenant::Mysql::NoTenantRegistratedError.new("No tenant registered: #{tenant_name}")
        end
        true
      end
    end

    class ConnectionSwitcher
      attr_accessor :action_controller, :method

      def initialize(action_controller, method)
        @action_controller = action_controller
        @method            = method
      end

      def self.set_tenant(tenant_name)
        return unless Tenant.exists?(tenant_name)
        DB.establish_connection_for tenant_name
      end

      def execute
        tenant_name = action_controller.send(method)
        return unless Tenant.exists?(tenant_name)
        DB.establish_connection_for tenant_name
      end
    end

  end
end
