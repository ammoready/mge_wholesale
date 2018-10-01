module MgeWholesale
  class Inventory < Base

    INVENTORY_FILENAME = 'exportXML_cq_barcodeFFL.csv'.freeze
    FULL_INVENTORY_FILENAME = 'exportXML_cq_barcodeFFL_all.csv'.freeze

    def initialize(options = {})
      requires!(options, :username, :password)
      @options = options
    end

    def self.all(options = {}, &block)
      requires!(options, :username, :password)
      new(options).all(&block)
    end

    def self.quantity(options = {}, &block)
      requires!(options, :username, :password)
      new(options).quantity(&block)
    end

    def all(&block)
      tempfile = get_file(INVENTORY_FILENAME)

      CSV.foreach(tempfile, { headers: :first_row }).each do |row|
        item = {
          item_identifier: row['id'],
          quantity:        row['qty'].to_i,
          price:           row['cost'],
        }

        yield(item)
      end

      tempfile.unlink
    end

    def quantity(&block)
      tempfile = get_file(FULL_INVENTORY_FILENAME)

      CSV.foreach(tempfile, { headers: :first_row }).each do |row|
        item = {
          item_identifier: row['id'],
          quantity:        row['qty'].to_i,
        }

        yield(item)
      end

      tempfile.unlink
    end

  end
end
