require 'spec_helper'

describe Multitenant::Mysql::Tenant do
  subject { Multitenant::Mysql::Tenant }

  before do
    create_table('subdomains')
    class Subdomain < ActiveRecord::Base; end;
  end

  context '#exists?' do
    it 'should return true for existing tenant' do
      mock = double('Subdomain')
      Subdomain.stub(:where).and_return([mock])
      expect(subject.exists?('blade')).to be_true
    end

    it 'should return true for blank name' do
      expect(subject.exists?('')).to be_true
    end

    it 'should raise an error for unexisting tenant' do
      ActiveRecord::Base.stub(:where).and_return(nil)
      expect { subject.exists?('invalid tenant') }.to raise_error(Multitenant::Mysql::NoTenantRegistratedError)
    end
  end

end

describe Multitenant::Mysql::ConnectionSwitcher do
  context '#set_tenant' do
    subject { Multitenant::Mysql::ConnectionSwitcher }

    before do
      Multitenant::Mysql::Tenant.stub(:exists?).and_return(true)
    end

    it 'should change db connection' do
      Multitenant::Mysql::DB.should respond_to(:establish_connection_for)
      Multitenant::Mysql::DB.should_receive(:establish_connection_for).with('tenant')
      expect{ subject.set_tenant('tenant') }.to_not raise_error
    end
  end

  context '.execute' do
    let(:mock_ac) { double('ActionController::Base') }

    subject { Multitenant::Mysql::ConnectionSwitcher.new(mock_ac, :tenant) }

    it 'should change db connection' do
      Multitenant::Mysql::Tenant.stub(:exists?).and_return(true)
      mock_ac.should_receive(:send).with(:tenant).and_return('wallmart')
      Multitenant::Mysql::DB.should_receive(:establish_connection_for).with('wallmart')
      expect { subject.execute }.to_not raise_error
    end
  end
end
