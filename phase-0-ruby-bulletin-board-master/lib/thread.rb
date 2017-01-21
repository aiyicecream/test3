require_relative 'id'

module RubyBulletinBoard
  # class Thread
  class Thread
    attr_reader :uuid, :creator_uuid
    attr_accessor :title

    def initialize(user)
      @uuid = IdCreator.create_id
      @creator_uuid = user.uuid
      @title = ""
    end
  end
end
