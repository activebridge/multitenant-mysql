require 'spec_helper'

describe ActionController::Base do
  subject { ActionController::Base }

  context '.set_current_tenant' do
    it 'should raise an error when no tenant method provided' do
      expect { subject.set_current_tenant }.to raise_error
    end

    it 'should establish connection' do
      mock = double('Multitenant::Mysql::ConnectionSwitcher')
      mock.stub(:execute).and_return('ok')
      Multitenant::Mysql::ConnectionSwitcher.should_receive(:new).and_return(mock)
      subject.set_current_tenant(:name)

      expect( subject.new.establish_tenant_connection ).to eql('ok')
    end
  end
end
