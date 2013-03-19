module Multitenant
  module Mysql
    module Configs
      class Base
        attr_accessor :models, :bucket

        def tenants_bucket(name)
          raise InvalidBucketError.new('Multitenant::Mysql: invalid bucket') if name.blank?

          @bucket = Bucket.new(name)
          yield(@bucket) if block_given?
        end

        def tenant
          @bucket.model
        end
      end
    end
  end
end
