require 'multitenant-mysql/version'
require 'multitenant-mysql/active_record_extension'
require 'multitenant-mysql/action_controller_extension'
require 'multitenant-mysql/conf_file'

require_relative '../rails/init'

module Multitenant
  module Mysql

    class << self

      DEFAULT_TENANT_NAME_ATTR = [:name, :title]

      def active_record_configs=(configs)
        @configs = configs
      end

      def active_record_configs
        @configs
      end

      alias_method :arc, :active_record_configs

      def tenant
        arc[:tenant_model][:name].constantize
      rescue
        if arc.blank? || arc[:tenant_model].blank? || arc[:tenant_model][:name].blank?
          raise "
            Multitenant::Mysql: You should specify model which stores info about tenants.
            E.g. in initializer:
            Multitenant::Mysql.arc = {
              tenant_model: { name: 'Subdomain' }
            }
          "
        else
          raise "Please check your multitenant-mysql configs. Seems like you are trying to use model which doesn't exist: #{arc[:tenant_model][:name]}"
        end
      end

      def models
        active_record_configs[:models]
      end

      def tenant_name_attr
        return active_record_configs[:tenant_model][:tenant_name_attr] if active_record_configs[:tenant_model][:tenant_name_attr]

        DEFAULT_TENANT_NAME_ATTR.each do |name|
          return name if tenant.column_names.include?(name.to_s)
        end

        raise 'You should specify tenant name attribute or use one default: name, title'
      end

    end

  end
end
