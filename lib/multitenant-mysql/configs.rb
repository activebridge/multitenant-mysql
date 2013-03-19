require_relative './configs/bucket'
require_relative './configs/base'

module Multitenant
  module Mysql
    class << self
      def configure &block
        raise InvalidConfigsError.new('Multitenant::Mysql: No configs provided') unless block_given?
        configs = Configs::Base.new
        block.call(configs)
        self.configs = configs
      end

      def configs=configs
        @configs = configs
      end

      def configs
        @configs
      end
    end
  end
end
