require_relative "../lib/rbb_db"
require_relative "../lib/user"
require 'sqlite3'

RSpec.describe RubyBulletinBoard::RBBDatabase do
  let (:rbb_db) { RubyBulletinBoard::RBBDatabase.new }
  it 'can create a db' do
    # p rbb_db.db
    # p rbb_db.db.class

    # cmd = rbb_db.db.prepare "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"
    # result_set = cmd.execute
    # result_set.each { |row| p row }
    expect(rbb_db.db).to be_kind_of(SQLite3::Database)
  end

  it 'has a users table' do
    cmd = rbb_db.db.prepare "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"
    result_set = cmd.execute
    array_of_hashes = []
    result_set.each { |row| array_of_hashes << row }

    result = array_of_hashes.select { |hash| hash["name"] == "users" }
    result_desired = [{"name"=>"users"}]

    expect(result).to eq(result_desired)
  end

  # it 'can insert users' do
  #   rbb_db.drop_users
  #   rbb_db.create_users
  #   some_user = RubyBulletinBoard::User.new("matz", "umoto")
  #   rbb_db.insert_user(some_user)
  #   select_all_users_cmd = rbb_db.db.prepare "select * from users"
  #   users_from_db = []
  #   select_all_users_cmd.execute.each { |row| users_from_db << row }
  #   # p users_from_db

  #   result = users_from_db.select { |hash| hash["uuid"] == some_user.uuid }
  #   result_desired = [some_user.as_hash]

  #   # p some_user.as_hash
  #   expect(result).to eq(result_desired)
  # end

  it 'can delete users' do
    rbb_db.refresh_users
    some_user = RubyBulletinBoard::User.new("matz", "umoto").hash_representation

    # p "before insertion"
    # rbb_db.display_users

    rbb_db.insert_user(some_user)

    # p "after insertion"
    # rbb_db.display_users

    rbb_db.delete_user(some_user["uuid"])

    # p "after deletion"
    # rbb_db.display_users

    select_all_users_cmd = rbb_db.db.prepare "select * from users"
    users_from_db = []
    select_all_users_cmd.execute.each { |row| users_from_db << row }
    # p users_from_db

    result = users_from_db.select { |hash| hash["uuid"] == some_user.uuid }
    result_desired = []

    # p some_user.as_hash
    expect(result).to eq(result_desired)
  end

  it 'can give users as usable hash: {"uuid" => user' do
      rbb_db.refresh_users
      some_user = RubyBulletinBoard::User.new("matz", "umoto").hash_representation
      another_user = RubyBulletinBoard::User.new("foo", "bar").hash_representation
      rbb_db.insert_user(some_user)
      rbb_db.insert_user(another_user)

      usable_hash = rbb_db.give_users_as_hash
      expect(usable_hash).to eq({some_user["uuid"] => some_user, another_user["uuid"]=>another_user})
  end

  it 'can refresh the db' do
      rbb_db.refresh_users
      some_user = RubyBulletinBoard::User.new("matz", "umoto").hash_representation
      another_user = RubyBulletinBoard::User.new("foo", "bar").hash_representation
      rbb_db.insert_user(some_user)
      rbb_db.insert_user(another_user)

      rbb_db.refresh_users

      expect(rbb_db.give_users_as_hash).to eq({})
  end

end
