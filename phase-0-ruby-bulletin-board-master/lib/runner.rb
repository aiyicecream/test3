
require_relative 'example'
require_relative 'bulletin_board'
require_relative "user"
require_relative "colored/lib/colored"

module RubyBulletinBoard
  class Runner
    # attr_accessor :greeter, :thread

    def initialize
      # @greeter = RSpecGreeter.new
      # @thread = RubyBulletinBoard::Thread.new
      @help_message =\
        <<-msg
(#{"h".bold})elp (#{"u".bold})sers (#{"l".bold})ogin [name] [password] (#{"c".bold})reate [name] [password] (#{"r".bold})emove [name] [password] (#{"q".bold})uit
       msg
       end

       # def run
       #     greeter.greet
       #     # p @thread.class
       # end
       def run
         rbb = RubyBulletinBoard::BulletinBoard.new

         system("clear")
         # rbb.display_users

         input = ""
         i = 0

         # puts "(h)elp (u)sers (c)reate [name] [password] (r)emove [name] [password] (q)uit"
         print @help_message
         while (input != "q")
           current_user = rbb.users[rbb.current_user_uuid]
           current_user_name = current_user["user_name"]

           print "[#{i}] rbb(#{current_user_name})> "
           input = gets.chomp
           input_arr = input.split(" ")

           if input_arr[0] == 'q'
             # do nothing cause we're outta here
             # not true anymore, we gotta sync :)
             rbb.conditional_sync
           elsif input_arr[0] == 'u'
             rbb.display_users
           elsif input_arr[0] == 'c'
             # need to make sure users don't repeat
             # there should be better error messages
             new_user = rbb.create_user_in_users(input_arr[1], input_arr[2])
             if new_user != nil
               puts "new user: #{new_user["user_name"]} created"
             else
               puts "invalid input"
             end

           elsif input_arr[0] == 'r'
            # still need to protect from removing current user
            
             # I need to get that user's uuid
             # lets just assume unique users for now :)
             user_in_hash = rbb.users.select do |uuid, user|
               user["user_name"] == input_arr[1] && \
                 user["password"] == input_arr[2]
             end
             if user_in_hash != {}
               user_uuid = user_in_hash.first[0]
               rbb.remove_user(user_uuid)
               puts "user: #{input_arr[1]} removed"
             else
               puts "invalid input"
             end
           elsif input_arr[0] == 'l'
             user_in_hash = rbb.users.select do |uuid, user|
               user["user_name"] == input_arr[1] && \
                 user["password"] == input_arr[2]
             end
             # did the user_name and password match?
             # if they did then the hash is not empty
             # and it hold the uuid for the user trying to
             # log in
             if user_in_hash != {}
               rbb.current_user_uuid = user_in_hash.first[0]
             else
               puts "invalid input"
             end

           elsif input_arr[0] == 'h'
             print @help_message
           end
           i += 1
         end
       end
       end
       end
