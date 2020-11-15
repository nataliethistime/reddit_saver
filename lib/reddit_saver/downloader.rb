require_relative 'configuration'

require 'forwardable'
require 'redd'
require 'down'

module RedditSaver
  class Downloader
    extend Forwardable

    def_delegators :@config, :setup, :verify_config!

    def initialize
      @config = Configuration.new
      @looked_at = 0
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

      puts "Done. Looked at #{@looked_at} posts."
    end

    def download_collection(collection)
      collection.each { |post| download_post(post) }
    end

    def download_post(post)
      @looked_at += 1
      extension = File.extname(URI.parse(post.url).path)
      return if extension.empty? || extension.nil? || extension == '.gifv'
      author = post.author.name
      author = 'unknown' if author == '[deleted]'
      subreddit = post.subreddit.display_name
      path = File.join(@config.download_dir, "u-#{author}-r-#{subreddit}-#{post.id}#{extension}")
      return if File.exists?(path)
      puts post.url
      puts path
      Down.download(
        post.url,
        destination: path,
        headers: {
          'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36'
        }
      )
    rescue Down::NotFound
      puts 'Not found.'
    end
  end
end
