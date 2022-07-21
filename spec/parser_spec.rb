require 'ostruct'
require 'byebug'

RSpec.describe F1SalesCustom::Email::Parser do
  context 'when came from the website' do
    let(:email) do
      email = OpenStruct.new
      email.to = [email: 'mkt@hdfveiculos.com.br']
      email.subject = 'NOVO LEAD INTERESSADO EM COMPRAR CARRO'
      email.body = "Assunto: NOVO LEAD INTERESSADO EM COMPRAR CARRO\nData: 2022-05-17 14:33\nDe: HDF Veículos <mkt@hdfveiculos.com.br>\nPara: contato@hdfveiculos.com.br\nCópia: mkt@hdfveiculos.com.br\n\nNome: Nilma Teixeira de Souza\nTelefone: 31975733529\nData de Nascimento: 04/01/1973\nNº do CPF:: 5293810600\nQual valor da entrada?: 6.000\nPossui CNH?: Não\nEmail: tnilma3@gmail.com\n\n---\n\nDate: 17/05/2022\nTime: 14:33\nPage URL: https://hdfveiculos.com.br/carros/chevrolet-celta-1-0-2004/\nUser Agent: Mozilla/5.0 (Linux; Android 7.1.2; LM-X210)\nAppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.61 Mobile\nSafari/537.36\nRemote IP: 45.70.159.115\nPowered by: Elementor"

      email
    end

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains lead website a source name' do
      expect(parsed_email[:source][:name]).to eq('Website')
    end

    it 'contains name' do
      expect(parsed_email[:customer][:name]).to eq('Nilma Teixeira de Souza')
    end

    it 'contains phone' do
      expect(parsed_email[:customer][:phone]).to eq('31975733529')
    end

    it 'contains email' do
      expect(parsed_email[:customer][:email]).to eq('tnilma3@gmail.com')
    end

    it 'contains CPF' do
      expect(parsed_email[:customer][:cpf]).to eq('5293810600')
    end

    it 'contains link page' do
      expect(parsed_email[:product][:link]).to eq('https://hdfveiculos.com.br/carros/chevrolet-celta-1-0-2004/')
    end

    it 'contains message' do
      expect(parsed_email[:message]).to eq('Valor de entrada: R$ 6.000 - Possui CNH: Não')
    end

    it 'contains product name' do
      expect(parsed_email[:product][:name]).to eq('')
    end
  end
end
