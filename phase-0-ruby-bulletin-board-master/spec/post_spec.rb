# require 'ruby_bulletin_board/post'
require_relative '../lib/post'
require_relative "../lib/user"
require_relative "../lib/thread"

RSpec.describe RubyBulletinBoard::Post do
    let (:post) { RubyBulletinBoard::Post.new(RubyBulletinBoard::User.new("guest","").uuid, RubyBulletinBoard::Thread.new(RubyBulletinBoard::User.new("guest","")).uuid) }
    it { expect(post).to be_kind_of(RubyBulletinBoard::Post) }    

    it 'has a valid uuid' do
        # p post.uuid
        expect(post.uuid).to be_kind_of(String)
    end

    it 'has editable content' do
        default_content = post.content
        post.content = "#{default_content} something different"
        new_content = post.content
        expect(default_content == new_content).to eq(false)
    end

    it 'has a creator_uuid' do
        some_user = RubyBulletinBoard::User.new("guest","")
        some_thread = RubyBulletinBoard::Thread.new(some_user)
        some_post = RubyBulletinBoard::Post.new(some_user.uuid, some_thread.uuid)
        expect(some_user.uuid == some_post.creator_uuid).to eq(true)
    end

    it 'has a thread_uuid' do
        some_user = RubyBulletinBoard::User.new("guest", "")
        some_thread = RubyBulletinBoard::Thread.new(some_user)
        some_post = RubyBulletinBoard::Post.new(some_user.uuid, some_thread.uuid)
        expect(some_thread.uuid == some_post.thread_uuid).to eq(true)
    end
end
