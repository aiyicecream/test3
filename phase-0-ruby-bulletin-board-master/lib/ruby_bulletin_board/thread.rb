require_relative 'id'

module RubyBulletinBoard
    class Thread
        attr_reader :uuid
        attr_accessor :title

        def initialize
           @uuid = IdCreator.create_id
           @title = title 
        end
    end
end