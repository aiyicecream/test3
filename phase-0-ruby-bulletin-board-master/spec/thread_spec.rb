# require 'ruby_bulletin_board/thread'
require_relative '../lib/thread'
require_relative "../lib/user"

RSpec.describe RubyBulletinBoard::Thread do
    let (:thread) {RubyBulletinBoard::Thread.new(\
        RubyBulletinBoard::User.new("guest", ""))}
    it { expect(thread).to be_kind_of(RubyBulletinBoard::Thread) }       

    it 'has a valid uuid' do
        # p thread.uuid
        expect(thread.uuid).to be_kind_of(String)
    end

    it 'has editable title' do
        default_title = thread.title
        thread.title = "#{default_title} something different"
        new_title = thread.title
        expect(default_title == new_title).to eq(false)
    end    

    it 'has a creator_uuid' do
        some_user = RubyBulletinBoard::User.new("guest", "")
        some_thread = RubyBulletinBoard::Thread.new(some_user)
        expect(some_user.uuid == some_thread.creator_uuid).to eq(true)
    end
end