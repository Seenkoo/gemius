require "gemius/version"
require "gemius/gemfile_lock"

module Gemius
  def self.gemfile_lock(filename)
    GemfileLock.new(File.read filename)
  end
end
