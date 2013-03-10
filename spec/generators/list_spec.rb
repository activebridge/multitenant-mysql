require 'spec_helper'

describe Multitenant::List do

  context 'views' do
    subject { Multitenant::List.new(Multitenant::SQL::VIEWS) }

    it 'should find all views' do
      create_view_for_table('books')
      expect(subject.to_a).to eq(['books_view'])
    end

    it 'should exist' do
      create_view_for_table('books')
      expect(subject.exists?('books_view')).to be
    end
  end

  context 'triggers' do
    subject { Multitenant::List.new(Multitenant::SQL::TRIGGERS) }

    it 'should find all triggers' do
      create_trigger_for_table('books')
      expect(subject.to_a).to eq(['books_tenant_trigger'])
    end

    it 'should exist' do
      create_trigger_for_table('books')
      expect(subject.exists?('books_tenant_trigger')).to be
    end
  end
  
end
