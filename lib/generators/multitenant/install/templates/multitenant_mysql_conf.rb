# Usage example:
#
#   Multitenant::Mysql.configure do |conf|
#     conf.models = ['Book', 'Task', 'Post']
#     conf.tenants_bucket 'Subdomain' do |tb|
#       tb.field = 'name'
#     end
#   end
#
# where:
# models - list of tenant dependent models
# tenants_bucket - model which stores all the tenants, as an argument recives the name of the model
#    field - attribute used to fetch tenant name (not required, default values are: name, title)

Multitenant::Mysql.configure do |conf|
  conf.models = []
  conf.tenants_bucket ''
end
