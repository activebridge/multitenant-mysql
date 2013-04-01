require 'spec_helper'

describe Multitenant::Mysql::Configs::Bucket do
  context '#field' do
    subject { Multitenant::Mysql::Configs::Bucket.new('Post') }

    before do
      create_table('posts')
      Multitenant::Mysql.stub_chain(:configs, :tenant?).and_return(true)
      Multitenant::Mysql.stub_chain(:configs, :models).and_return([])
      class Post < ActiveRecord::Base; end;
    end

    it 'should use default' do
      expect(subject.field).to eql(:name)
    end

    it 'should use specific one' do
      subject.field = 'tenant'
      expect(subject.field).to eql('tenant')
    end

    it 'should raise error for invalid field' do
      subject.field = 'unexisting column'
      expect { subject.field }.to raise_error(Multitenant::Mysql::InvalidBucketFieldError)
    end
  end
end
