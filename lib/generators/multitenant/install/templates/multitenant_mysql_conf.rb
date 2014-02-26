# Usage example:
#
#   Multitenant::Mysql.configure do |conf|
#     conf.models = ['Book', 'Task', 'Post']
#     conf.tenants_bucket 'Subdomain' do |tb|
#       tb.field = 'name'
#       tb.super_tenant_identifier = 'optimus_prime'
#     end
#   end
#
# where:
# models                    - list of tenant dependent models
# tenants_bucket            - model which stores all the tenants, as an argument recives the name of the model
# field                     - attribute used to fetch tenant (not required, default values are: name, title)
# super_tenant_identifier   - name (or 'field' attribute value) of tenant to be used as super-admin, able to access all
#                             data regardless of tenant. (optional)


Multitenant::Mysql.configure do |conf|
  conf.models = []
  conf.tenants_bucket ''
end
