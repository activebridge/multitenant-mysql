# simple example
#
# Multitenant::Mysql.arc = {
#   models: ['Book', 'Task'],
#   tenant_model: { name: 'Subdomain', tenant_name_attr: name }
# }
#
# where:
# models - list of tenant related models
# tenant_model - model where tenant info is stored
#   name - model name
#   tenant_name_attr - attribute used to fetch tenant name

Multitenant::Mysql.arc = {
  models: [],
  tenant_model: { name: '' }
}
