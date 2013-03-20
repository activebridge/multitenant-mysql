require 'spec_helper'

describe ActiveRecord::Base do
  subject { ActiveRecord::Base }
  it 'should respond to acts_as_tenant' do
    subject.should respond_to(:acts_as_tenant)
  end

  it 'should respond to acts_as_tenants_bucket' do
    subject.should respond_to(:acts_as_tenants_bucket)
  end

  it 'should redefine table name and primary key and keep original table name' do
    ActiveRecord::Base.stub_chain(:connection, :table_exists?).and_return(true)

    Multitenant::Mysql.stub_chain(:configs, :models).and_return(['Book'])
    Multitenant::Mysql.stub_chain(:configs, :tenant).and_return(false)

    class Book < ActiveRecord::Base
    end

    expect(Book.table_name).to eql('books_view')
    expect(Book.primary_key).to eql('id')
    expect(Book.original_table_name).to eql('books')
  end
end
