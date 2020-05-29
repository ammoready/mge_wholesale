require 'spec_helper'

describe MgeWholesale::Catalog do

  let(:credentials) { { username: '100001', password: 'pass' } }

  it 'has CATALOG_FILENAME constant' do
    expect(defined?(MgeWholesale::Catalog::CATALOG_FILENAME)).to eq('constant')
  end

  it 'has PERMITTED_FEATURES constant' do
    expect(defined?(MgeWholesale::Catalog::PERMITTED_FEATURES)).to eq('constant')
  end

  describe '.all' do
    before do
      tempfile = Tempfile.new(['vendorname_items', '.xml'])
      FileUtils.copy_file(FixtureHelper.get_fixture_file('vendorname_items.xml').path, tempfile.path)
      allow_any_instance_of(MgeWholesale::Catalog).to receive(:get_file) { tempfile }
    end

    it 'yields items' do
      count = 0
      MgeWholesale::Catalog.all(credentials) do |item|
        count += 1
        case count
        when 1
          expect(item[:item_identifier]).to eq('A12300011')
        when 2
          expect(item[:item_identifier]).to eq('A12300012')
          # It accounts for their misspelling
          expect(item[:features][:magnification]).to eq('10x')
        end
      end
    end
  end

end
