module RedditSaver
  class Utilities
    def self.sanitize_filename(name)
      name
        .gsub(/[^0-9A-Za-z\-]/, '-') # Replace all non-ASCII chars with -'s
        .gsub(/^-+/, '') # Leading -'s
        .gsub(/-+$/, '') # Trailing -'s
        .gsub(/-{2,}/, '') # Two or more -'s
        .downcase
    end
  end
end
