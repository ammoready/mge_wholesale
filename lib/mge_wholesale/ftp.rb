module MgeWholesale
  class FTP

    attr_reader :connection

    def initialize(credentials)
      @connection ||= Net::FTP.new(MgeWholesale.config.ftp_host)
      @connection.passive = true
      self.login(credentials[:username], credentials[:password])
    end

    def login(username, password)
      @connection.login(username, password)
    rescue Net::FTPPermError
      raise MgeWholesale::NotAuthenticated
    end

    def close
      @connection.close
    end

  end
end
