module MgeWholesale
  class Base

    def self.connect(options = {})
      requires!(options, :username, :password)

      Net::FTP.open(MgeWholesale.config.ftp_host, options[:username], options[:password]) do |ftp|
        begin
          ftp.debug_mode = MgeWholesale.config.debug_mode
          ftp.passive = true
          yield ftp
        ensure
          ftp.close
        end
      end
    rescue Net::FTPPermError => e
      raise case
      when e.message =~ /no such file or directory/i
        MgeWholesale::FileOrDirectoryNotFound
      else
        MgeWholesale::NotAuthenticated
      end
    end

    protected

    # Wrapper to `self.requires!` that can be used as an instance method.
    def requires!(*args)
      self.class.requires!(*args)
    end

    def self.requires!(hash, *params)
      params.each do |param|
        if param.is_a?(Array)
          raise ArgumentError.new("Missing required parameter: #{param.first}") unless hash.has_key?(param.first)

          valid_options = param[1..-1]
          raise ArgumentError.new("Parameter: #{param.first} must be one of: #{valid_options.join(', ')}") unless valid_options.include?(hash[param.first])
        else
          raise ArgumentError.new("Missing required parameter: #{param}") unless hash.has_key?(param)
        end
      end
    end

    # Instance methods become class methods through inheritance
    def connect(options)
      self.class.connect(options) do |ftp|
        begin
          yield ftp
        ensure
          ftp.close
        end
      end
    end

    def get_file(filename, file_directory = nil)
      connect(@options) do |ftp|
        begin
          tempfile = Tempfile.new

          ftp.chdir(file_directory || MgeWholesale.config.top_level_dir)
          ftp.getbinaryfile(filename, tempfile.path)

          tempfile
        ensure
          ftp.close
        end
      end
    end

    def content_for(xml_doc, field)
      node = xml_doc.css(field).first

      if node.nil?
        nil
      else
        node.content.try(:strip)
      end
    end

  end
end
