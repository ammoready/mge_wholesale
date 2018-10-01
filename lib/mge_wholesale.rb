require 'mge_wholesale/version'

require 'csv'
require 'net/ftp'
require 'tempfile'

require 'nokogiri'
require 'active_support/all'

require 'mge_wholesale/base'
require 'mge_wholesale/catalog'
require 'mge_wholesale/category'
require 'mge_wholesale/inventory'
require 'mge_wholesale/order'
require 'mge_wholesale/user'

module MgeWholesale
  class InvalidOrder < StandardError; end
  class NotAuthenticated < StandardError; end

  class << self
    attr_accessor :config
  end

  def self.config
    @config ||= Configuration.new
  end

  def self.configure
    yield(config)
  end

  class Configuration
    attr_accessor :debug_mode
    attr_accessor :ftp_host
    attr_accessor :top_level_dir

    def initialize
      @debug_mode    ||= false
      @ftp_host      ||= "ftp.mgegroup.com"
      @top_level_dir ||= "ffldealer"
    end
  end
end
