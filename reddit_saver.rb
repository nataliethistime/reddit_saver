require 'rubygems'
require 'bundler/setup'

require_relative 'lib/reddit_saver'
require 'optparse'

puts "Running reddit_saver version #{RedditSaver::VERSION}"

downloader = RedditSaver::Downloader.new

downloader.setup do |config|
  config.download_dir = File.join(__dir__, 'downloads')

  parser = OptionParser.new do |opts|
    opts.banner = 'Usage: reddit_saver.rb [options]'

    opts.on('--upvoted', 'Download upvoted posts') do |upvoted|
      config.upvoted = upvoted
    end

    opts.on('--saved', 'Download saved posts') do |saved|
      config.saved = saved
    end

    opts.on('--username USERNAME', 'Username to authenticate with') do |username|
      config.username = username
    end

    opts.on('--password PASSWORD', 'Password to authenticate with') do |password|
      config.password = password
    end
  end

  parser.parse!
end

downloader.verify_config!
downloader.perform!
