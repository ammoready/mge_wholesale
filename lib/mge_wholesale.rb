require 'mge_wholesale/version'

require 'net/ftp'
require 'tempfile'

# these can be commented out when the gem is bundled into a Rails app
require 'nokogiri'
require 'active_support/all'

require 'mge_wholesale/base'
require 'mge_wholesale/ftp'
require 'mge_wholesale/catalog'
require 'mge_wholesale/category'
require 'mge_wholesale/inventory'
#require 'mge_wholesale/order'
#require 'mge_wholesale/response_file'
require 'mge_wholesale/user'
#require 'mge_wholesale/brand_converter'

module MgeWholesale
  #TODO: handle orders
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
    attr_accessor :response_dir
    attr_accessor :submission_dir
    attr_accessor :top_level_dir

    def initialize
      @debug_mode     ||= false
      @ftp_host       ||= "ftp.mgegroup.com"
      @top_level_dir  ||= "ffldealer"
      @submission_dir ||= ""
      @response_dir   ||= ""
    end

    def full_submission_dir
      File.join(@top_level_dir, @submission_dir)
    end

    def full_response_dir
      File.join(@top_level_dir, @response_dir)
    end
  end
end
