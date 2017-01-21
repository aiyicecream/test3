require 'securerandom'
module RubyBulletinBoard
  class IdCreator
    def self.create_id
      SecureRandom.uuid
    end
  end
end
