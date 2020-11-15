require_relative 'configuration'
require_relative 'utilities'

require 'net/http'
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

      download_collection(@connection.me.saved(sort: :new, time: :all)) if @config.saved
      download_collection(@connection.me.liked(sort: :new, time: :all)) if @config.upvoted
    end

    def download_collection(collection)
      collection.each { |post| download_post(post) }
    end

    def download_post(post)
      extension = File.extname(URI.parse(post.url).path)
      filename = Utilities.sanitize_filename("u-#{post.author.name}-#{post.title}-#{post.id}")
      path = File.join(@config.download_dir, "#{filename}#{extension}")
      puts post.url
      puts path
      res = Net::HTTP.get(URI(post.url))
      File.write(path, res)
    end
  end
end
