require_relative './configs/bucket'
require_relative './configs/centralized'

module Multitenant
  module Mysql
    class Configs
      attr_accessor :refresh_on_migrate, :centralized

      def initialize(centralized)
        @centralized        = centralized
        @refresh_on_migrate = true
      end

      def centralized_mode(enable = true)
        @centralized_mode = enable

        return unless enable
        if enable && !block_given?
          raise '
            you should provie configs or disable centralized mode by
            conf.centralized_mode false
          '
        end
        yield(centralized)
      end

      def centralized?
        @centralized_mode
      end
    end

    class << self
      def configure &block
        raise 'Multitenant::Mysql: No configs provided' unless block_given?
        centralized = Centralized.new
        configs = Configs.new(centralized)
        block.call(configs)
        Multitenant::Mysql.configs = configs
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
