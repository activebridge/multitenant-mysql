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
    Multitenant::Mysql.stub_chain(:configs, :models).and_return(['Book'])
    Multitenant::Mysql.stub_chain(:configs, :tenant?).and_return(false)
    create_table('books')
    create_view_for_table('books')

    class Book < ActiveRecord::Base
    end

    expect(Book.table_name).to eql('books_view')
    expect(Book.primary_key).to eql('id')
    expect(Book.original_table_name).to eql('books')
  end

  context 'bucket' do
    it 'should create new mysql account' do
      Multitenant::Mysql.stub_chain(:configs, :models).and_return([])
      Multitenant::Mysql.stub_chain(:configs, :tenant?).and_return(true)
      Multitenant::Mysql.stub_chain(:configs, :bucket_field).and_return('name')
      Multitenant::Mysql::DB.stub_chain(:configs, :[]).and_return($cnf['password'])

      create_table('users')
      create_view_for_table('users')
      class User < ActiveRecord::Base; end;

      mock_connection = double
      mock_connection.should_receive(:execute).with("GRANT ALL PRIVILEGES ON *.* TO 'default_name'@'localhost' IDENTIFIED BY '#{$cnf['password']}' WITH GRANT OPTION;").once
      mock_connection.should_receive(:execute).with("flush privileges;").once
      Multitenant::Mysql::DB.stub(:connection).and_return(mock_connection)

      expect(User.create(name: 'default_name', tenant: 'bla bla bla')).to be
    end
  end
end
