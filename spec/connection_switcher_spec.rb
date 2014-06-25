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
      allow(Subdomain).to receive(:where).and_return([mock])
      expect(subject.exists?('blade')).to be true
    end

    it 'should return true for blank name' do
      expect(subject.exists?('')).to be true
    end

    it 'should raise an error for unexisting tenant' do
      allow(ActiveRecord::Base).to receive(:where).and_return(nil)
      expect { subject.exists?('invalid tenant') }.to raise_error(Multitenant::Mysql::NoTenantRegisteredError)
    end
  end

end

describe Multitenant::Mysql::ConnectionSwitcher do
  context '#set_tenant' do
    subject { Multitenant::Mysql::ConnectionSwitcher }

    before { allow(Multitenant::Mysql::Tenant).to receive(:exists?).and_return(true) }

    it 'should change db connection' do
      expect(Multitenant::Mysql::DB).to respond_to(:establish_connection_for)
      allow(Multitenant::Mysql::DB).to receive(:establish_connection_for).and_return('tenant')
      expect{ subject.set_tenant('tenant') }.to_not raise_error
    end
  end

  context '.execute' do
    let(:mock_ac) { double('ActionController::Base') }

    subject { Multitenant::Mysql::ConnectionSwitcher.new(mock_ac, :tenant) }

    it 'should change db connection' do
      allow(Multitenant::Mysql::Tenant).to receive(:exists?).and_return(true)
      allow(mock_ac).to receive(:send).with(:tenant).and_return('wallmart')
      allow(Multitenant::Mysql::DB).to receive(:establish_connection_for).with('wallmart')
      expect { subject.execute }.to_not raise_error
    end
  end
end
