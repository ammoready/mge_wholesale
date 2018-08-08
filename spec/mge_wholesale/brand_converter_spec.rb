require 'spec_helper'

describe MgeWholesale::BrandConverter do

  describe '.convert' do
    it 'finds the corresponding brand for 2A' do
      expect(MgeWholesale::BrandConverter.convert('2A 1122')).to eq('2A Armament')
    end

    it 'finds the corresponding brand for GLOCK' do
      expect(MgeWholesale::BrandConverter.convert('GLOCK G43')).to eq('Glock')
    end

    it 'finds the corresponding brand for OAI' do
      expect(MgeWholesale::BrandConverter.convert('oai')).to eq('Olympic Arms')
    end
  end

end
