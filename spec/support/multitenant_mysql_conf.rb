Multitenant::Mysql.active_record_configs = {
  models: ['Book'],
  tenant_model: { name: 'Subdomain', tenant_name_attr: 'title' }
}
