module RedditSaver
  class Configuration
    REQUIRED = [:username, :password, :download_dir]
    attr_accessor :saved, :upvoted, :subreddits, :users, :username, :password, :download_dir

    def initialize
      @saved = false
      @upvoted = false
      @subreddits = []
      @users = []
    end

    def setup
      yield self
    end

    def verify_config!
      REQUIRED.each do |arg|
        raise ArgumentError, "Did not provide #{arg}" if self.public_send(arg).nil?
      end
    end
  end
end
