require 'rubygems'
require 'bundler/setup'

require 'active_record'
require 'action_controller'
require 'multitenant-mysql'

RSpec.configure do |config|
  Multitenant::Mysql::ConfFile.path = File.expand_path('../', __FILE__) + '/support/multitenant_mysql_conf'
  CONF_FILE_PATH = File.expand_path('../', __FILE__) + '/support/multitenant_mysql_conf'
end
