require_relative "id"

module RubyBulletinBoard
  class User
    attr_reader :uuid
    attr_accessor :user_name, :password, :hash_representation

    def initialize (user_name, password, uuid="")
      #check if a uuid was passed
      if uuid == ""
        @uuid = IdCreator.create_id
      else
        @uuid = uuid
      end
      @user_name = user_name
      @password = password
      @hash_representation = {"uuid"=>@uuid, "user_name"=>@user_name, "password"=>@password}
    end

    def as_hash 
        user_as_hash = {}
        user_as_hash["uuid"] = @uuid
        user_as_hash["user_name"] = @user_name
        user_as_hash["password"] = @password
        user_as_hash
    end
  end
end
