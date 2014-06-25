require 'spec_helper'

describe ActiveRecord::Base do
  subject { ActiveRecord::Base }
  it 'should respond to acts_as_tenant' do
    expect(subject).to respond_to(:acts_as_tenant)
  end

  it 'should respond to acts_as_tenants_bucket' do
    expect(subject).to respond_to(:acts_as_tenants_bucket)
  end

  it 'should redefine table name and primary key and keep original table name' do
    allow(Multitenant::Mysql).to receive_message_chain(:configs, :models).and_return(['Book'])
    allow(Multitenant::Mysql).to receive_message_chain(:configs, :tenant?).and_return(false)
    allow(Multitenant::Mysql).to receive_message_chain(:configs, :bucket, :has_super_tenant_identifier?).and_return(false)
    create_table('books')
    create_view_for_table('books')

    class Book < ActiveRecord::Base
    end

    expect(Book.table_name).to eql('books_view')
    expect(Book.primary_key).to eql('id')
    expect(Book.original_table_name).to eql('books')
  end

  context 'bucket' do

    before do
      allow(Multitenant::Mysql).to receive_message_chain(:configs, :models).and_return([])
      allow(Multitenant::Mysql).to receive_message_chain(:configs, :tenant?).and_return(true)
      allow(Multitenant::Mysql).to receive_message_chain(:configs, :bucket_field).and_return('name')
      allow(Multitenant::Mysql::DB).to receive_message_chain(:configs, :[]).and_return($cnf['password'])
      allow(Multitenant::Mysql).to receive_message_chain(:configs, :bucket, :has_super_tenant_identifier?).and_return(false)
      create_bucket('users')
      class User < ActiveRecord::Base; end;
    end

    it 'should create new mysql account' do
      mock_connection = double
      allow(mock_connection).to receive(:execute).with("GRANT ALL PRIVILEGES ON *.* TO 'default_name'@'localhost' IDENTIFIED BY '#{$cnf['password']}' WITH GRANT OPTION;").once
      allow(mock_connection).to receive(:execute).with("flush privileges;").once
      allow(Multitenant::Mysql::DB).to receive(:connection).and_return(mock_connection)

      expect(User.create(name: 'default_name')).to be
    end

    it 'should remove mysql account' do
      ActiveRecord::Base.connection.execute("INSERT INTO `users` (`name`) VALUES ('default_name')")
      mock_connection = double

      allow(mock_connection).to receive(:execute).with("DELETE FROM mysql.user where user='default_name';").once
      allow(mock_connection).to receive(:execute).with("flush privileges;").once
      allow(Multitenant::Mysql::DB).to receive(:connection).and_return(mock_connection)

      user = User.find_by_name('default_name')
      expect(user.destroy).to be
    end
  end
end
