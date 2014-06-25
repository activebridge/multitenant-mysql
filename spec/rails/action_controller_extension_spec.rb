require 'spec_helper'

describe ActionController::Base do

  context '.set_current_tenant' do
    subject { ActionController::Base }

    it 'should raise an error when no tenant method provided' do
      expect { subject.set_current_tenant }.to raise_error
    end

    it 'should establish connection' do
      mock = double('Multitenant::Mysql::ConnectionSwitcher')
      allow(mock).to receive(:execute).and_return('ok')
      allow(Multitenant::Mysql::ConnectionSwitcher).to receive(:new).and_return(mock)
      subject.set_current_tenant(:name)

      expect( subject.new.establish_tenant_connection ).to eql('ok')
    end
  end

  context '.set_current_tenant_by_subdomain' do
    subject { ActionController::Base.new }

    before do
      ActionController::Base.set_current_tenant_by_subdomain
    end

    it 'should set current tenant by subdomain' do
      allow(subject).to receive_message_chain(:request, :subdomain).and_return('yahoo')
      allow(Multitenant::Mysql::ConnectionSwitcher).to receive(:set_tenant).with('yahoo').and_return(true)

      expect( subject.establish_tenant_connection_by_subdomain ).to be
    end
  end
end
