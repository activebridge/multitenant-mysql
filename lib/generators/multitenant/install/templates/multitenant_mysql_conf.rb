# There are two options:
# 1 You could explicitly specify tenant dependent models by adding `acts_as_tenant`, in this case you don't need this file or it would look like
#   Multitenant::Mysql.configure do |conf|
#     conf.centralized_mode false
#   end
#
# 2 If you are too lazy to find all tenant dependent models and you prefer too keep a sinle list with all you models then you need configs like
#   Multitenant::Mysql.configure do |conf|
#     conf.centralized_mode do |c|
#       c.models = ['Book', 'Task', 'Post']
#       c.tenants_bucket 'Subdomains' do |tb|
#         tb.field = 'name'
#       end
#     end
#   end
#
# where:
# models - list of tenant dependent models
# tenants_bucket - model which stores all the tenants, as an arbument recives the name of the model
#    field - attribute used to fetch tenant name (not required, default values are: name, title)

Multitenant::Mysql.configure do |conf|
  conf.refresh_on_migrate = false

  conf.centralized_mode do |c|
    c.models = []
    c.tenants_bucket ''
  end
end

