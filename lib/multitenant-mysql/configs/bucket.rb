module Multitenant
  module Mysql
    module Configs
      class Bucket
        DEFAULT_TENANT_NAME_ATTR = [:name, :title]
        attr_accessor :name, :field, :super_tenant_identifier

        def initialize(name)
          @name = name
        end

        def model
          @name.constantize
        rescue
          if @name.blank?
            raise InvalidBucketError.new('Multitenant::Mysql: You should specify model which stores info about tenants.')
          else
            raise InvalidBucketError.new("Please check your multitenant-mysql configs. Seems like you are trying to use model which doesn't exist: #{@name}")
          end
        end

        def field
          @field ||= default_field
          @field || raise(InvalidBucketFieldError.new('Multitenant::Mysql: You should specify tenants bucket field or use one default: name, title'))
          raise InvalidBucketFieldError.new("Multitenant::Mysql: #{model} doesn't have '#{@field}' attribute") unless validate_field?
          @field
        end

        def has_super_tenant_identifier?
          super_tenant_identifier.present?
        end

        def super_tenant
          model.send("find_by_#{field}".to_sym, super_tenant_identifier)
        end

        private

        def default_field
          DEFAULT_TENANT_NAME_ATTR.each do |n|
            return n if model.column_names.include?(n.to_s)
          end
        end

        def validate_field?
          @valid ||= model.column_names.include?(@field.to_s)
        end
      end
    end
  end
end
