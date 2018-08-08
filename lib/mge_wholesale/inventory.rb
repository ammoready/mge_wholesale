module MgeWholesale
  class Inventory < Base

    INVENTORY_FILENAME = 'exportXML_cq_barcodeFFL.xml'

    def initialize(options = {})
      requires!(options, :username, :password)
      @options = options
    end

    def self.all(options = {}, &block)
      requires!(options, :username, :password)
      new(options).all(&block)
    end

    def self.get_quantity_file(options = {})
      requires!(options, :username, :password)
      new(options).get_quantity_file
    end

    def self.quantity(options = {}, &block)
      requires!(options, :username, :password)
      new(options).all(&block)
    end

    def all(&block)
      tempfile = get_file(INVENTORY_FILENAME)

      Nokogiri::XML(tempfile).xpath('//item').each do |item|
        yield map_hash(item)
      end

      tempfile.close
      tempfile.unlink
    end

    def get_quantity_file
      inventory_tempfile = get_file(INVENTORY_FILENAME)
      tempfile           = Tempfile.new

      Nokogiri::XML(inventory_tempfile).xpath('//item').each do |item|
        tempfile.puts("#{content_for(item, 'id')},#{content_for(item, 'qty')}")
      end

      inventory_tempfile.close
      inventory_tempfile.unlink
      tempfile.close
      tempfile.path
    end

    alias quantity all

    private

    def map_hash(node)
      {
        item_identifier: content_for(node, 'id'),
        quantity:        content_for(node, 'qty').to_i,
        price:           content_for(node, 'cost')
      }
    end

  end
end
