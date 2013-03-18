module Multitenant
  module Mysql
    class Bucket
      DEFAULT_TENANT_NAME_ATTR = [:name, :title]
      attr_accessor :name, :field

      def initialize(name)
        @name = name
      end

      def model
        @name.constantize
      rescue
        if @name.blank?
          raise "Multitenant::Mysql: You should specify model which stores info about tenants."
        else
          raise "Please check your multitenant-mysql configs. Seems like you are trying to use model which doesn't exist: #{@name}"
        end
      end

      def field
        return @field if @field

        DEFAULT_TENANT_NAME_ATTR.each do |name|
          return name if model.column_names.include?(name.to_s)
        end

        raise 'You should specify tenant name attribute or use one default: name, title'
      end
    end
  end
end
