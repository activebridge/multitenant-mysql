require_relative './configs/bucket'
require_relative './configs/centralized'

module Multitenant
  module Mysql
    class Configs
      attr_accessor :refresh_on_migrate, :centralized

      def initialize(options = {})
        @refresh_on_migrate = options[:refresh_on_migrate] || false
        @enable_centralized_mode   = options[:enable_centralized_mode] || false
      end

      def centralized_mode(enable = false)
        @enable_centralized_mode = enable
        if block_given?
          yield(centralized)
          @enable_centralized_mode = true
        end

        if enable && !block_given?
          raise '
            you should provie a block or disable centralized mode by
            conf.centralized_mode false
          '
        end
      end

      def centralized_mode?
        @enable_centralized_mode
      end
    end

    class << self
      def configure &block
        raise 'Multitenant::Mysql: No configs provided' unless block_given?
        configs = Configs.new
        configs.centralized = Centralized.new
        block.call(configs)
        self.configs = configs
      end

      def configs=configs
        @configs = configs
      end

      def configs
        @configs
      end

      def configure_default
        self.configs = Configs.new
      end
    end
  end
end

Multitenant::Mysql.configure_default
