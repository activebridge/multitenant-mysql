require 'spec_helper'

# n.b. Not quite sure where to put this - kind of an integration test, not in the sense of a request spec but to test
# that all parts of the library work together and access the right data for the given context.
describe 'Querying data' do

  before do
    Multitenant::Mysql::DB.configs['adapter'] = 'mysql2'
    Multitenant::Mysql::DB.configs['host'] = 'localhost'
    Multitenant::Mysql::DB.configs['database'] = 'tenant_test'
    Multitenant::Mysql::DB.configs['password'] = ''

    Multitenant::Mysql.configure do |conf|
      conf.models = ['Book']
      conf.tenants_bucket 'Subdomain' do |tb|
        tb.super_tenant_identifier = 'abracadabra'
      end
    end

    create_table 'books'
    create_trigger_for_table 'books'
    create_view_for_table 'books'

    class Subdomain < ActiveRecord::Base; end

    create_table 'subdomains'

    %w(foo bar abracadabra).each do |name|
      Subdomain.create name: name
    end

    class Book < ActiveRecord::Base; end
  end

  let!(:foo_book) {
    Multitenant::Mysql::ConnectionSwitcher.set_tenant 'foo'
    Book.create name: 'foo_book'
  }

  let!(:bar_book) {
    Multitenant::Mysql::ConnectionSwitcher.set_tenant 'bar'
    Book.create name: 'bar_book'
  }

  context 'Using foo subdomain' do

    before do
      Multitenant::Mysql::ConnectionSwitcher.set_tenant 'foo'
    end

    subject { Book.all }

    its(:count) { should == 1 }
    it { should include foo_book }
    it { should_not include bar_book }

  end

  context 'Using bar subdomain' do

    before do
      Multitenant::Mysql::ConnectionSwitcher.set_tenant 'bar'
    end

    subject { Book.all }

    its(:count) { should == 1 }
    it { should_not include foo_book }
    it { should include bar_book }

  end

  context 'Using super-tenant subdomain' do

    before do
      Multitenant::Mysql::ConnectionSwitcher.set_tenant 'abracadabra'
    end

    subject { Book.all }

    its(:count) { should == 2 }
    it { should include foo_book }
    it { should include bar_book }

  end

end