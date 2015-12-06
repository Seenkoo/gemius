require "gemius/version"
require "gemius/gemfile_lock"

module Gemius
  def self.gemfile_lock(path_or_content)
    if File.file?(path_or_content)
      GemfileLock.new(File.read path_or_content)
    else
      GemfileLock.new(path_or_content)
    end
  end
end
