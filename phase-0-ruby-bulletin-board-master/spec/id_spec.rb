# require 'ruby_bulletin_board/id'
require 'id'

RSpec.describe RubyBulletinBoard::IdCreator do
  it 'creates ids' do
    id = RubyBulletinBoard::IdCreator.create_id
    # p id
    expect(id).to be_kind_of(String)
  end
end
