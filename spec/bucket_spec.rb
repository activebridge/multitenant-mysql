require 'spec_helper'

describe Multitenant::Mysql::Configs::Bucket do

  before do
    create_table('posts')
    Multitenant::Mysql.stub_chain(:configs, :tenant?).and_return(true)
    Multitenant::Mysql.stub_chain(:configs, :models).and_return([])
    Multitenant::Mysql.stub_chain(:configs, :bucket_field).and_return('name')
    class Post < ActiveRecord::Base; end;
  end

  subject { Multitenant::Mysql::Configs::Bucket.new('Post') }

  context '#field' do

    it 'should use default' do
      expect(subject.field).to eql(:name)
    end

    it 'should use specific one' do
      subject.field = 'tenant'
      expect(subject.field).to eql('tenant')
    end

    it 'should raise error for invalid field' do
      subject.field = 'nonexistent column'
      expect { subject.field }.to raise_error(Multitenant::Mysql::InvalidBucketFieldError)
    end
  end

  context '#super_tenant' do

    context 'when no identifier has been specified' do
      its(:has_super_tenant_identifier?) { should be_false }
    end

    context 'with an identifier' do

      before do
        subject.super_tenant_identifier = 'super_admin'
      end

      its(:has_super_tenant_identifier?) { should be_true }

      context 'without a matching record' do
        its(:super_tenant) { should be_nil }
      end

      context 'with a matching record' do
        let!(:super_tenant_instance) { Post.create name: 'super_admin' }

        its(:super_tenant) { should == super_tenant_instance }
      end
    end
  end
end
