require 'spec_helper'

describe Multitenant::Mysql do
  subject { Multitenant::Mysql }

  context '#configure' do
    it 'should raise error with no block given' do
      expect { subject.configure }.to raise_error(Multitenant::Mysql::InvalidConfigsError)
    end

    context 'with valid params' do
      before do
        class Subdomain; end;
        subject.configure do |conf|
          conf.models = ['Book']
          conf.tenants_bucket 'Subdomain'
        end
      end

      it 'should be of valid type' do
        expect(subject.configs).to be_kind_of Multitenant::Mysql::Configs::Base
      end

      it 'should have valid values' do
        expect(subject.configs.models).to eql(['Book'])
        expect(subject.configs.tenant).to eql(Subdomain)
      end
    end
  end

  context '#configs=' do
    let(:configs) { Multitenant::Mysql::Configs::Base.new }

    it 'should set configs' do
      subject.configs = configs
      expect(subject.configs).to eql(configs)
    end
  end
end
