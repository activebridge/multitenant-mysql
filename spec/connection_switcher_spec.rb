require 'spec_helper'

describe Multitenant::Mysql::ConnectionSwitcher do
  before do
    Multitenant::Mysql.stub(:tenant_name_attr).and_return('name')
  end

  context '#execute' do
    it 'should raise error if there is no tenant account in db' do
      ar_mock = double('ActiveRecord::Relation')
      ar_mock.stub(:where).and_return(nil)
      Multitenant::Mysql.stub(:tenant).and_return(ar_mock)

      ac_mock = double('ActionController::Base')
      ac_mock.should_receive(:send).and_return('unexisting tenant')
      switcher = Multitenant::Mysql::ConnectionSwitcher.new(ac_mock, :tenant_method)
      Multitenant::Mysql::DB.stub(:configs).and_return({ 'username' => 'root' })

      expect { switcher.execute }.to raise_error(Multitenant::Mysql::NoTenantRegistratedError)
    end

    it 'should change db connection' do
      ar_mock = double('ActiveRecord::Relation')
      ar_mock.stub(:where).and_return(:some_result)
      Multitenant::Mysql.stub(:tenant).and_return(ar_mock)

      ac_mock = double('ActionController::Base')
      ac_mock.should_receive(:tenant_method)
      switcher = Multitenant::Mysql::ConnectionSwitcher.new(ac_mock, :tenant_method)
      Multitenant::Mysql::DB.stub(:configs).and_return({ 'username' => 'root' })

      ActiveRecord::Base.should_receive(:establish_connection)

      expect( switcher.execute ).to be
    end
  end

  context '.set_tenant' do
    subject { Multitenant::Mysql::ConnectionSwitcher }

    it 'should change db connection' do
      Multitenant::Mysql::Tenant.stub(:exists?).and_return(true)
      Multitenant::Mysql::DB.stub(:configs).and_return({ 'username' => 'root' })

      ActiveRecord::Base.should_receive(:establish_connection).with({ 'username' => 'google'})
      expect( subject.set_tenant('google') ).to be
    end
  end
end
