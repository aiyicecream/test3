require 'sqlite3'
require_relative "user"

class Hash
  def difference(other)
    reject do |k,v|
      other.has_key? k
    end
  end
end

module RubyBulletinBoard
  class RBBDatabase
    attr_accessor :db

    def initialize()
      @db = SQLite3::Database.new("rbb_db.db")
      @db.results_as_hash = true

      create_user_in_users
    end

    def insert_user (user)
      # p user.uuid.class
      # print "insert into users values(\"#{user.uuid}\", \"#{user.user_name}\", \"#{user.password}\")"
      insert_user_cmd = @db.prepare "insert or ignore into users values(\"#{user["uuid"]}\", \"#{user["user_name"]}\", \"#{user["password"]}\")"
      insert_user_cmd.execute
    end

    def insert_users_hashy_hash(users_hashy_hash)
    	# find which pairs need to be loaded up
    	not_in_database = users_hashy_hash.difference(give_users_as_hash)
    	not_in_database.each do |uuid, hash_representation|
    		insert_user(hash_representation)
    	end
    end

    def delete_user(user_uuid)
        delete_user_cmd = @db.prepare "delete from users where uuid=\"#{user_uuid}\""
      delete_user_cmd.execute
    end

    def drop_users
      drop_users_cmd = @db.prepare "drop table users"
      drop_users_cmd.execute
    end

    def refresh_users
        drop_users
        create_user_in_users
    end

    def create_user_in_users
      create_user_in_users_table_cmd = @db.prepare "CREATE TABLE IF NOT EXISTS users( uuid varchar(255), user_name varchar(255), password varchar(255), unique(user_name))"
      create_user_in_users_table_cmd.execute
    end

    def display_users (debug=false)
        select_users_cmd = @db.prepare "select * from users"
        if debug == true
            select_users_cmd.execute.each { |hash| p hash }
        else
            select_users_cmd.execute.each { |hash| puts hash["user_name"]}
        end

    end

    def give_users_as_hash
        usable_users_hash = {}
        select_users_cmd = @db.prepare "select * from users"
        select_users_cmd.execute.each do |row|
            tmp_user = RubyBulletinBoard::User.new(row["user_name"], row["password"], row["uuid"])
            usable_users_hash[row["uuid"]] = tmp_user.hash_representation
        end

        usable_users_hash
    end

  end
end
