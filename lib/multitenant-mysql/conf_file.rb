module Multitenant
  module Mysql
    class ConfFile
      def self.path=(path)
        @path = path
      end

      def self.path
        # workaround to reqire conf file in rails app
        @path ||= default_path
      end

      def self.full_path
        "#{path}.rb"
      end

      def self.default_path
        Rails.root.to_s + '/config/multitenant_mysql_conf'
      end
    end
  end
end
