require_relative "user"
require_relative "rbb_db"
require "sqlite3"

module RubyBulletinBoard
  class BulletinBoard
    attr_accessor :users, :current_user_uuid, :guest_user
    attr_reader :rbb_database

    # not sure if I should be passing users as an arg
    # because we're going to be reading it from the db
    # later
    def initialize()
      # probably will need to read from db here
      @rbb_database = RubyBulletinBoard::RBBDatabase.new
      # @users = @rbb_database.give_users_as_hash
      @users = {}
      # conditionally sync with the database :)
      conditional_sync
      # eventually need to add @threads, and @posts

      # when initialized the default user is guest with no password
      # but we need to know about the guest.uuid for later
      # also will probably need to check db here
      # right on past max, we do need to check the db here :)
      if name_is_available?("guest")
      	@guest_user = create_user_in_users("guest", "")
      else
      	@guest_user = find_user_by_user_name("guest")
      end

      # sync with database on creation and right before quitting

      # p "---inside BulletinBoard#initialize---"
      # p "before the sync, @guest_user:"
      # p @guest_user
      # sync
      # p "after the sync, @guest_user"
      # p "-----"

      # p @guest_user.uuid
      @current_user_uuid = @guest_user["uuid"]
    end

    # this can't be the most efficient way by a mile
    # but lets just see if it works
    # def sync
    #   rbb_db = SQLite3::Database.new("../rbb_db.db")
    #   rbb_db.results_as_hash = true

    #   p "array_with_hashes_inside"
    #   p array_with_hashes_inside = rbb_db.execute("select * from users")

    #   usable_hash = {}
    #   array_with_hashes_inside.each do |hash|
    #     usable_hash[hash["uuid"]] = create_user_in_users(hash["user_name"], hash["password"],hash["uuid"])
    #   end

    #   @users.merge(usable_hash)
    # end

    # need to check if user_name already exists
    def name_is_available?(user_name)
      hash_of_users = @users.select do |uuid, user|
        user["user_name"] == user_name
      end
      # if it's empty then it's all good
      return hash_of_users == {}
    end

    # create a new user but return the
    # hash representation which makes it easier
    # to interact with the database,
    # I'm not sure if this is best way.

    # note: users are now created as hash_representations
    def create_user_in_users(user_name, password)
      # need to check to see if user already exists
      if name_is_available?(user_name)
        # create the new user
        new_user = RubyBulletinBoard::User.new(user_name, password).hash_representation
        store_user_in_hash(new_user)
      else
        # p "user_name is already taken"
        nil
      end
    end

    def store_user_in_hash(user_as_hash)
      @users[user_as_hash["uuid"]] = user_as_hash
    end

    def find_user_by_user_name(user_name)
    	found_user = @users.select{|uuid, hash| hash["user_name"] == user_name }
    	found_user.first[1]
    end

    def remove_user(user_uuid)
      # do I need to also clean the user out from memory?
      # talk to the database
      @users.delete(user_uuid)
    end

    def clear_users
      @users = {}
    end

    def display_users
      user_name_array = @users.collect do |uuid, user|
        user["user_name"]
      end
      display_string = user_name_array.join("\n")
      puts display_string
      display_string
    end

    # conditionally merges two hashes and gives precedence to
    # the database
    def conditional_merge(users_hash, db_hash)
      # create a hash to return
      merged_hash = {}

      # create a hash that will flip the uuid and user_name so users_flipped_kinda["user_name"] = "uuid"
      users_flipped_kinda = {}

      users_hash.each do |uuid, hash_representation|
        users_flipped_kinda[hash_representation["user_name"]] = uuid
      end
      # p users_flipped_kinda

      db_hash.each do |uuid, hash_representation|
        # if there is a conflict then handle it
        if users_flipped_kinda.include?(hash_representation["user_name"])
          # delete the right uuid from users_hash
          users_uuid = users_flipped_kinda[hash_representation["user_name"]]
          users_hash.delete(users_uuid)
        end

        # load up db_hash pairs no matter what
        merged_hash[uuid] = hash_representation
      end

      # merge what's left
      # p users_hash
      merged_hash.merge!(users_hash)
      merged_hash
    end
    
    def conditional_sync
    	merged_hash = conditional_merge(@users, @rbb_database.give_users_as_hash)
    	@users = merged_hash
    	@rbb_database.insert_users_hashy_hash(merged_hash)

    	# p "---inside conditional_sync---"
    	# p @users
    	# p @rbb_database.give_users_as_hash
    	# puts "---"
    end
  end
end
