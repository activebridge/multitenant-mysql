module Multitenant
  module SQL
    VIEWS = "SELECT TABLE_NAME FROM information_schema.`TABLES` WHERE TABLE_TYPE LIKE 'VIEW' AND TABLE_SCHEMA LIKE '#{Multitenant::Mysql::DB.configs['database']}';"
    TRIGGERS = "SELECT trigger_name FROM information_schema.TRIGGERS where trigger_schema = '#{Multitenant::Mysql::DB.configs['database']}';"
  end
end
