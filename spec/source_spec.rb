require 'ostruct'
require 'byebug'

RSpec.describe F1SalesCustom::Email::Source do
  context 'when came from the website' do
    it 'support website source' do
      expect(described_class.support?('website')).to be_truthy
    end

    it 'support contato source' do
      expect(described_class.support?('contato')).to be_truthy
    end
  end
end
