module Multitenant
  module Mysql
    class InvalidBucketError < StandardError; end;
    class NoTenantRegistratedError < StandardError; end;
    class InvalidConfigsError < StandardError; end;
    class InvalidBucketFieldError < StandardError; end;
    class InvalidTenantError < StandardError; end;
  end
end
