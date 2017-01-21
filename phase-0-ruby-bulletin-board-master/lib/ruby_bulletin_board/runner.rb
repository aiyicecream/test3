require_relative 'example'
# require_relative 'thread'

module RubyBulletinBoard
    class Runner
        attr_accessor :greeter, :thread

        def initialize
            @greeter = RSpecGreeter.new
            # @thread = RubyBulletinBoard::Thread.new
        end

        def run
            greeter.greet
            # p @thread.class
        end
    end
end
