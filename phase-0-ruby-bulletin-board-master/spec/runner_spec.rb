# require 'ruby_bulletin_board/runner'
require 'runner'

RSpec.describe RubyBulletinBoard::Runner do
  let (:runner) {RubyBulletinBoard::Runner.new }
  it { expect(runner).to be_kind_of(RubyBulletinBoard::Runner) }

  # it 'RubyBulletinBoard::Runner.run' do
  #   expect(runner.run).to eq("Hello world!")
  # end
end
