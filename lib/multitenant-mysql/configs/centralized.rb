module Multitenant
  module Mysql
    class Centralized
      attr_accessor :models, :bucket
      def tenants_bucket(name)
        @bucket = Bucket.new(name)
        if block_given?
          yield(bucket)
        end
      end

      def tenant
        @bucket.model
      end
    end
  end
end
