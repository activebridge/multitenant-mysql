require 'spec_helper'

describe Multitenant::Mysql::DB do
  subject { Multitenant::Mysql::DB }
  let(:configs) { { 'username' => 'root', 'password' => 'password' } }

  context '#configs' do
    it 'should set configs' do
      subject.configs = configs
      expect(subject.configs).to eql(configs)
    end

    it 'should get configs' do
      class Rails; end;
      allow(Rails).to receive_message_chain(:configuration, :database_configuration, :[]).and_return(configs)

      expect(subject.configs['username']).to eql('root')
      expect(subject.configs['password']).to eql('password')
    end
  end

  context '#establish_connection_for' do
    it 'should change db connection with root account' do
      subject.configs = configs
      allow(ActiveRecord::Base).to receive(:establish_connection).with({ 'username' => 'root', 'password' => 'password' })
      expect { subject.establish_connection_for(nil) }.to_not raise_error
    end

    it 'should change db connection for particular tenant' do
      subject.configs = configs
      allow(ActiveRecord::Base).to receive(:establish_connection).with({ 'username' => 'wallmart', 'password' => 'password' })
      expect { subject.establish_connection_for('wallmart') }.to_not raise_error
    end
  end
end
