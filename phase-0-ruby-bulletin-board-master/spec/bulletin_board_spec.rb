require_relative "../lib/post"
require_relative "../lib/user"
require_relative "../lib/thread"
require_relative "../lib/bulletin_board"

def refresh_database_and_give_new_bulletin
  RubyBulletinBoard::RBBDatabase.new.refresh_users
  some_bulletin = RubyBulletinBoard::BulletinBoard.new()
  some_bulletin
end

RSpec.describe RubyBulletinBoard::BulletinBoard do
  # let (:bulletin_board) { RubyBulletinBoard::BulletinBoard.new() }
  it 'exists' do
    some_bulletin = refresh_database_and_give_new_bulletin
    expect(some_bulletin).to be_kind_of(RubyBulletinBoard::BulletinBoard)
  end

  it 'has a hash of users' do
    some_bulletin = refresh_database_and_give_new_bulletin
    expect(some_bulletin.users).to be_kind_of(Hash)
  end

  # # will probably comment this out later
  # it 'is empty on init right now' do
  #   some_bulletin = refresh_database_and_give_new_bulletin
  #   database_as_hash = some_bulletin.rbb_database.give_users_as_hash
  #   puts "check users hash:"
  #   bulletin_board_hash = some_bulletin.users

  #   expect(database_as_hash == bulletin_board_hash).to eq(true)
  # end

  it 'can create a guest_user with user_name:guest pw:""' do
    some_bulletin = refresh_database_and_give_new_bulletin
    some_user = some_bulletin.create_user_in_users("guest", "")
    if some_user != nil
      expect(some_user["user_name"] == "guest" && some_user["password"] == "").to eq(true)
    else
      expect(some_user == nil).to eq(true)
    end
  end

  it 'can store users in @users hash' do
    some_bulletin = refresh_database_and_give_new_bulletin
    some_user = some_bulletin.create_user_in_users("guest", "")
    if some_user != nil
      some_bulletin.store_user_in_hash(some_user)
      expect(some_bulletin.users[some_user["uuid"]] == some_user).to eq(true)
    else
      expect(some_user == nil).to eq(true)
    end
  end

  it 'prevents creation of users the same user_name' do
    some_bulletin = refresh_database_and_give_new_bulletin
    some_user = some_bulletin.create_user_in_users("guest", "")
    another_user = some_bulletin.create_user_in_users("guest", "")

    # p some_bulletin.users.length
    # p some_user
    # p some_user["uuid"]
    # p some_bulletin.users
    # p some_bulletin.users[some_user["uuid"]]
    # p some_bulletin.users.key?(some_user["uuid"])
    expect(some_bulletin.users.length == 1).to eq(true)
  end

  # note: there's some weirdness about if what a RubyBulletinBoard::User is now
  # I basically just keep turned them into hashes
  # is this right? It's so it's easier to interact with the db
  # but I'm not sure
  # it 'can create a BulletinBoard#guest_user with user_name:guest pw:""' do
  #   some_bulletin = refresh_database_and_give_new_bulletin
  #   some_bulletin.guest_user = some_bulletin.create_user_in_users("guest", "")
  #   expect(some_bulletin.guest_user["user_name"] == "guest" && some_bulletin.guest_user["password"] == "").to eq(true)
  # end

  it 'creates a BulletinBoard#guest_user with user_name:guest pw:"" on initialization' do
    some_bulletin = refresh_database_and_give_new_bulletin
    # p some_bulletin.guest_user
    expect(some_bulletin.guest_user["user_name"] == "guest" && some_bulletin.guest_user["password"] == "").to eq(true)
  end

  it 'has the current_user_uuid' do
    some_bulletin = refresh_database_and_give_new_bulletin
    expect(some_bulletin.current_user_uuid).to be_kind_of(String)
  end

  it 'can set/change the current_user_uuid' do
    some_bulletin = refresh_database_and_give_new_bulletin
    some_user = RubyBulletinBoard::User.new("some_user", "some_password").hash_representation

    before = some_bulletin.current_user_uuid
    some_bulletin.current_user_uuid = some_user["uuid"]
    after = some_bulletin.current_user_uuid

    expect(before == some_bulletin.guest_user["uuid"] && after == some_user["uuid"]).to eq(true)
  end

  it 'display users by user_name on their own line' do
    some_bulletin = refresh_database_and_give_new_bulletin
    some_bulletin.create_user_in_users("foo", "bar")
    some_bulletin.create_user_in_users("matz", "catz")

    expected_string = "guest\nfoo\nmatz"
    displayed_string = some_bulletin.display_users
    expect(expected_string == displayed_string).to eq(true)
  end

  it 'removes users' do
    some_bulletin = refresh_database_and_give_new_bulletin

    # puts "inside removes users"
    # some_bulletin.display_users

    some_user = some_bulletin.create_user_in_users("max", "catsanddogs")

    # puts "after creating max"
    # some_bulletin.display_users

    some_bulletin.remove_user(some_user["uuid"])

    expected_hash = {
      some_bulletin.guest_user["uuid"] => some_bulletin.guest_user
    }

    expect(some_bulletin.users).to eq(expected_hash)
  end

  it 'can clear @users' do
    some_bulletin = refresh_database_and_give_new_bulletin

    # puts "-----"
    # puts "inside clear @users test before"
    # some_bulletin.display_users
    # some_bulletin.remove_user(some_bulletin.guest_user.uuid)
    # puts "inside clear @users test after"
    # some_bulletin.display_users
    # p some_bulletin.users
    # puts "-----"
    some_bulletin.clear_users
    expect(some_bulletin.users).to eq({})
  end

  # conditionally merges two hashes and gives precedence to
  # the database
  it 'RubyBulletinBoard::BulletinBoard.conditionally_merge' do
    some_bulletin = refresh_database_and_give_new_bulletin
    pretend_users = {
      "a42e6110-a4e9-4bdb-bc5b-26b78cd74227"=>{"uuid"=>"a42e6110-a4e9-4bdb-bc5b-26b78cd74227", "user_name"=>"guest", "password"=>"leave"},
      "b42e6110-a4e9-4bdb-bc5b-26b78cd74227"=>{"uuid"=>"b42e6110-a4e9-4bdb-bc5b-26b78cd74227", "user_name"=>"foo", "password"=>"stay"}
    }
    pretend_db = {
      "c42e6110-a4e9-4bdb-bc5b-26b78cd74227"=>{"uuid"=>"c42e6110-a4e9-4bdb-bc5b-26b78cd74227", "user_name"=>"guest", "password"=>"stay"},
      "d42e6110-a4e9-4bdb-bc5b-26b78cd74227"=>{"uuid"=>"d42e6110-a4e9-4bdb-bc5b-26b78cd74227", "user_name"=>"matz", "password"=>"stay"}
    }

    synced_hash = some_bulletin.conditional_merge(pretend_users, pretend_db)

    expected_hash = {
      "c42e6110-a4e9-4bdb-bc5b-26b78cd74227"=>{"uuid"=>"c42e6110-a4e9-4bdb-bc5b-26b78cd74227", "user_name"=>"guest", "password"=>"stay"},
      "d42e6110-a4e9-4bdb-bc5b-26b78cd74227"=>{"uuid"=>"d42e6110-a4e9-4bdb-bc5b-26b78cd74227", "user_name"=>"matz", "password"=>"stay"},
      "b42e6110-a4e9-4bdb-bc5b-26b78cd74227"=>{"uuid"=>"b42e6110-a4e9-4bdb-bc5b-26b78cd74227", "user_name"=>"foo", "password"=>"stay"}
    }
    # p expected_hash

    expect(synced_hash == expected_hash).to eq(true)
  end

  it 'conditionally syncs with the db' do
    some_bulletin = refresh_database_and_give_new_bulletin
    some_bulletin.conditional_sync
    expect(some_bulletin.users == some_bulletin.rbb_database.give_users_as_hash).to eq(true)
  end

  it 'finds a specific user_hash_representation by searching for user_name' do
    some_bulletin = refresh_database_and_give_new_bulletin
    pretend_db = {
      "c42e6110-a4e9-4bdb-bc5b-26b78cd74227"=>{"uuid"=>"c42e6110-a4e9-4bdb-bc5b-26b78cd74227", "user_name"=>"guest", "password"=>"stay"},
      "d42e6110-a4e9-4bdb-bc5b-26b78cd74227"=>{"uuid"=>"d42e6110-a4e9-4bdb-bc5b-26b78cd74227", "user_name"=>"matz", "password"=>"stay"}
    }
    some_bulletin.rbb_database.insert_users_hashy_hash(pretend_db)
    some_bulletin.conditional_sync

    # p "============"
    # p some_bulletin.users
    # p some_bulletin.rbb_database.give_users_as_hash
    # p "============"


    found_user_hash_representation = some_bulletin.find_user_by_user_name("matz")
    expect(found_user_hash_representation).to eq({"uuid"=>"d42e6110-a4e9-4bdb-bc5b-26b78cd74227", "user_name"=>"matz", "password"=>"stay"})
      end

  # it 'can sync with db on initialization' do
  #   some_bulletin = refresh_database_and_give_new_bulletin
  #   expect(some_bulletin.users == some_bulletin.rbb_database.give_users_as_hash).to eq(true)

  # end


end
