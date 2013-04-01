require 'rubygems'
require 'bundler/setup'

require 'active_record'
require 'action_controller'
require 'multitenant-mysql'

require 'coveralls'
Coveralls.wear!

GEM_ROOT_PATH = File.expand_path('../../', __FILE__)

require 'yaml'
$cnf = YAML::load_file(File.join(File.dirname(File.expand_path(__FILE__)), './conf/database.yml'))
ActiveRecord::Base.establish_connection($cnf)

RSpec.configure do |config|
  config.before do
    ActiveRecord::Base.connection.execute('drop database if exists `tenant_test`;')
    ActiveRecord::Base.connection.execute('create database `tenant_test`;')
    ActiveRecord::Base.connection.execute('use `tenant_test`;')


    Multitenant::Mysql.configure do |conf|
      conf.models = ['Book']
      conf.tenants_bucket 'Subdomain' do |tb|
        tb.field = 'name'
      end
    end
  end

  config.after do
    Object.send(:remove_const, :Subdomain) if defined?(Subdomain)
    Object.send(:remove_const, :Book) if defined?(Book)
  end
end

def create_table(name)
  ActiveRecord::Base.connection.execute("drop table if exists `#{name}`;")
  ActiveRecord::Base.connection.execute("create table `#{name}`
                                          (`id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
                                          `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
                                          `tenant` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL);")
end

def create_view_for_table(name)
  create_table(name)
  ActiveRecord::Base.connection.execute("
        CREATE VIEW #{name}_view AS
        SELECT id, name, tenant FROM #{name}
        ")
end

def create_trigger_for_table(name)
  create_table(name)
  ActiveRecord::Base.connection.execute("
        CREATE TRIGGER #{name}_tenant_trigger
        BEFORE INSERT ON #{name}
        FOR EACH ROW
        SET new.tenant = SUBSTRING_INDEX(USER(), '@', 1);
        ")
end

Multitenant::Mysql::DB.configs = { 'username' => 'root', 'database' => 'tenant_test' }

require GEM_ROOT_PATH + '/lib/generators/multitenant/views/sql/create'
require GEM_ROOT_PATH + '/lib/generators/multitenant/views/sql/drop'
require GEM_ROOT_PATH + '/lib/generators/multitenant/triggers/sql/create'
require GEM_ROOT_PATH + '/lib/generators/multitenant/triggers/sql/drop'
