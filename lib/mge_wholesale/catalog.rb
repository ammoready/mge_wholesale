module MgeWholesale
  class Catalog < Base

    CATALOG_FILENAME = 'vendorname_items.xml'
    ITEM_NODE_NAME   = 'item'

    PERMITTED_FEATURES = [
      'Action',
      'Barrel_Length',
      'Blade_Edge',
      'Blade_Finish',
      'Blade_Length',
      'Blade_Style',
      'Box_Qty',
      'Bullet_Type',
      'Caliber',
      'Caliber_Gauge',
      'Capacity',
      'Carry_Type',
      'Color',
      'Cutting_Edge',
      'Diameter',
      'Edge',
      'Finish',
      'Gauge',
      'Grain',
      'Grit',
      'Gun_Manufacturer',
      'Gun_Model',
      'L_x_W',
      'Magnifactaion',
      'Material',
      'Model',
      'OAL',
      'Reticle',
      'Shell_Length',
      'Shot',
      'Tube_Diameter',
      'Type'
    ]

    def initialize(options = {})
      requires!(options, :username, :password)
      @options = options
    end

    def self.all(options = {}, &block)
      requires!(options, :username, :password)
      new(options).all(&block)
    end

    def all(&block)
      tempfile = get_file(CATALOG_FILENAME)

      Nokogiri::XML::Reader.from_io(tempfile).each do |node|
        next unless node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT
        next unless node.name == ITEM_NODE_NAME

        yield map_hash(Nokogiri::XML::DocumentFragment.parse(node.inner_xml))
      end

      tempfile.close
      tempfile.unlink
    end

    protected

    def map_hash(node)
      features = map_features(node)

      {
        name:              content_for(node, 'name'),
        upc:               content_for(node, 'barcod'),
        item_identifier:   content_for(node, 'id'),
        quantity:          content_for(node, 'qty'),
        price:             content_for(node, 'price'),
        short_description: content_for(node, 'description'),
        category:          content_for(node, 'category'),
        subcategory:       content_for(node, 'subCategory'),
        mfg_number:        content_for(node, 'vendorItemNo'),
        weight:            content_for(node, 'Weight'),
        brand:             content_for(node, 'Brand'),
        features:          features
      }
    end

    def map_features(node)
      features = Hash.new

      node.elements.each do |n|
        if PERMITTED_FEATURES.include?(n.name.strip)
          # fix their typo
          n.name = "Magnification" if n.name.strip == "Magnifactaion"

          features[n.name.strip] = n.text.gsub("_", " ").strip
        end
      end

      features.delete_if { |k, v| v.to_s.blank? }
      features.transform_keys! { |k| k.downcase }
      features.transform_keys! { |k| k.gsub(/[^0-9A-Za-z\_]/, '') }
      features.symbolize_keys!
    end

  end
end
