require 'spec_helper'

describe Multitenant::Mysql do
  subject { Multitenant::Mysql }

  context 'active record configs' do

    it 'should raise error if no tenant name provided' do
      subject.active_record_configs = nil
      expect {
        subject.tenant_name_attr
      }.to raise_error
    end

    context 'tenant name attribute' do
      it 'should use name or title by default' do
        mock = double()
        mock.stub(:column_names).and_return(['name'])
        subject.stub(:tenant).and_return(mock)
        subject.stub(:active_record_configs).and_return({tenant_model: {}})
        expect(subject.tenant_name_attr).to eql(:name)

        mock.stub(:column_names).and_return(['title'])
        expect(subject.tenant_name_attr).to eql(:title)
      end

      it 'should use attribute from configs' do
        subject.stub(:active_record_configs).and_return({tenant_model: {tenant_name_attr: 'subdomain'}})
        expect(subject.tenant_name_attr).to eql('subdomain')
      end
    end

    context '.tenant' do
      before do
        Subdomain = :constant
      end

      it 'should find and return appropriate model' do
        subject.active_record_configs = { tenant_model: { name: 'Subdomain' } }
        expect(subject.tenant).to eq(Subdomain)
      end

      context 'invalid data' do
        it 'should raise error if no data provided' do
          subject.active_record_configs = {}
          expect { subject.tenant }.to raise_error(RuntimeError)
        end

        it 'should raise error if invalid data provided' do
          subject.active_record_configs = { tenant_model: { name: nil } }
          expect { subject.tenant }.to raise_error(RuntimeError)
        end

        it 'should raise error if invalid model provided' do
          subject.active_record_configs = { tenant_model: { name: 'UnexistingModelLa' } }
          expect { subject.tenant }.to raise_error(RuntimeError)
        end
      end
    end

    context '.models' do
      it 'should return listed models' do
        subject.active_record_configs = { models: ['Book', 'Task'] }
        expect(subject.models).to have(2).items
      end
    end

    context 'alias methods' do
      it 'should use aliased setter' do
        subject.arc = 'ARC'
        expect(subject.active_record_configs).to eql('ARC')
      end

      it 'should use aliased getter' do
        subject.active_record_configs = 'ABC'
        expect(subject.arc).to eql('ABC')
      end
    end

  end
end
