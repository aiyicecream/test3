require_relative 'id'

module RubyBulletinBoard
    class Post
        attr_reader :uuid, :creator_uuid, :thread_uuid
        attr_accessor :content

        def initialize(user_uuid, thread_uuid)
            @uuid = IdCreator.create_id
            @creator_uuid = user_uuid
            @thread_uuid = thread_uuid
            @content = ""
        end
    end
end