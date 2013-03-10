require 'spec_helper'

describe Multitenant::Triggers::SQL::Create do
  subject { Multitenant::Triggers::SQL::Create }

  it 'should generate trigger' do
    create_table('books')
    class Subdomain < ActiveRecord::Base; end;
    class Book < ActiveRecord::Base; end;
    subject.run
    expect( Multitenant::List.new(Multitenant::SQL::TRIGGERS).to_a ).to eq(['books_tenant_trigger'])
  end

end
