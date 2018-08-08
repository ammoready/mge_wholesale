require 'spec_helper'

describe MgeWholesale::Catalog do

  it 'has CATALOG_FILENAME constant' do
    expect(defined?(MgeWholesale::Catalog::CATALOG_FILENAME)).to eq('constant')
  end

  it 'has PERMITTED_FEATURES constant' do
    expect(defined?(MgeWholesale::Catalog::PERMITTED_FEATURES)).to eq('constant')
  end

end
