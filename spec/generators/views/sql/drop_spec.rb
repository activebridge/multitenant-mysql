require 'spec_helper'

describe Multitenant::Views::SQL::Drop do
  subject { Multitenant::Views::SQL::Drop }

  it 'should drop view' do
    create_view_for_table('books')
    class Subdomain < ActiveRecord::Base; end;
    class Book < ActiveRecord::Base; end;
    expect( Multitenant::List.new(Multitenant::SQL::VIEWS).to_a ).to eq(['books_view'])
    subject.run
    expect( Multitenant::List.new(Multitenant::SQL::VIEWS).to_a ).to be_empty
  end

end
