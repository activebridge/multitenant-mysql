require 'rubygems'
require 'bundler/setup'

require 'active_record'
require 'action_controller'
require 'multitenant-mysql'

RSpec.configure do |config|
  CONF_FILE_PATH = File.expand_path('../', __FILE__) + '/support/multitenant_mysql_conf'

  config.before do
    Multitenant::Mysql::ConfFile.path = CONF_FILE_PATH
  end
end
