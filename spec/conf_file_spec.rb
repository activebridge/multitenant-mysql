require 'spec_helper'

describe Multitenant::Mysql::ConfFile do
  subject { Multitenant::Mysql::ConfFile }

  context '.path' do
    it 'should return path' do
      subject.path = '/conf/file'
      expect(subject.path).to eql('/conf/file')
    end

    it 'should return default path to conf file in rails app' do
      path = 'Rails.root/config/multitenant_mysql_conf'

      subject.stub(:default_path).and_return(path)
      subject.path = nil

      expect(subject.path).to eql(path)
    end
  end

  context '.full_path' do
    it 'should return path with extension of the file' do
      subject.path = '/conf/file'
      expect(subject.full_path).to eql('/conf/file.rb')
    end

    it 'should return correct path no metter how many times we call it' do
      subject.path = '/conf/file'
      2.times do
        expect(subject.full_path).to eql('/conf/file.rb')
      end
    end
  end

  context '.default_path' do
    it 'should return path to conf file in rails app' do
      class Rails
        def self.root
          'Rails.root'
        end
      end

      expect(subject.default_path).to eql('Rails.root/config/multitenant_mysql_conf')
    end
  end

end
