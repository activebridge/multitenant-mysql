require 'spec_helper'

describe Multitenant::Views::SQL::Create do
  subject { Multitenant::Views::SQL::Create }

  it 'should generate view' do
    create_table('books')
    class Subdomain < ActiveRecord::Base; end;
    class Book < ActiveRecord::Base; end;
    subject.run
    expect( Multitenant::List.new(Multitenant::SQL::VIEWS).to_a ).to eq(['books_view'])
  end

end
