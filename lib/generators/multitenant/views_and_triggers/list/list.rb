module Multitenant
  class List
    attr_accessor :sql

    def initialize(sql = nil)
      @sql = sql
    end

    def to_a
      ActiveRecord::Base.connection.execute(sql).to_a.flatten
    end

    def exists?(name)
      to_a.include?(name)
    end
  end
end
