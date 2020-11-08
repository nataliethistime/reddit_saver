require_relative 'configuration'

require 'forwardable'
require 'redd'

module RedditSaver
  class Downloader
    extend Forwardable

    def_delegators :@config, :setup, :verify_config!

    def initialize
      @config = Configuration.new
    end

    def perform!
      @connection = Redd.it(
        user_agent: "ruby:reddit_saver:v#{::RedditSaver::VERSION} (by /u/the_real_1vasari)",
        client_id: '6rT_5fUzi9V1Cg',
        secret: 'mKBJiE_tRMX2ay9v9ytez6dcwDrzAA',
        username: @config.username,
        password: @config.password
      )

      saved = @connection.me.saved(sort: :new, time: :all).to_a
      # upvoted = @connection.me.liked

      saved.each do |post|
        puts post.url
      end
    end
  end
end
