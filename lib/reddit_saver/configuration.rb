module RedditSaver
  class Configuration
    attr_accessor :saved, :upvoted, :subreddits, :users, :username, :password

    def initialize
      @saved = false
      @upvoted = false
      @subreddits = []
      @users = []
    end

    def setup
      yield self
      puts self.inspect
    end

    def verify_config!
      puts 'All Good!'
    end
  end
end
