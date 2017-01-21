require_relative "../lib/user"

RSpec.describe RubyBulletinBoard::User do
  let (:user) { RubyBulletinBoard::User.new("guest", "password") }

  it 'exists' do
    expect(user).to be_kind_of(RubyBulletinBoard::User)
  end

  # this is really not DRY but I don't know how to use
  # guard or rspec well enough to reuse my tests accross
  # multiple describe blocks
  it 'has a valid uuid' do
    # p user.uuid
    expect(user.uuid).to be_kind_of(String)
  end

  it 'has editable user_name' do
    default_user_name = user.user_name
    user.user_name = "#{default_user_name} something different"
    new_user_name = user.user_name
    expect(default_user_name == new_user_name).to eq(false)
  end

  it 'has editable password' do
    default_password = user.password
    user.password = "#{default_password} something different"
    new_password = user.password
    expect(default_password == new_password).to eq(false)
  end
end
