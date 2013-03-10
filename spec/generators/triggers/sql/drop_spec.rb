require 'spec_helper'

describe Multitenant::Triggers::SQL::Drop do
  subject { Multitenant::Triggers::SQL::Drop }

  it 'should drop trigger' do
    create_trigger_for_table('books')
    class Subdomain < ActiveRecord::Base; end;
    class Book < ActiveRecord::Base; end;
    expect( Multitenant::List.new(Multitenant::SQL::TRIGGERS).to_a ).to eq(['books_tenant_trigger'])
    subject.run
    expect( Multitenant::List.new(Multitenant::SQL::TRIGGERS).to_a ).to be_empty
  end

end
