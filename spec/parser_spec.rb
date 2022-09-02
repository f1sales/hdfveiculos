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

  context 'when came from landing page' do
    let(:email) do
      email = OpenStruct.new
      email.to = [email: 'website@hdfveiculos.f1sales.net']
      email.subject = '[SPAM] New message from &quot;HDF Veculos&quot;'
      email.body = "Nome: Raphael Michelangelo\nCelular: 12997920040\nQual o veículo de interesse? : Celta\nCPF: 44489212306\nData de nascimento: 26/042004\nValor de entrada: 500\nPossui CNH?: Tô tirando\n\n---\n\nDate: 29/08/2022\nTime: 09:15\nPage URL:\nhttps://hdfveiculos.com.br/lp-carro-novo/?gclid=CjwKCAjwx7GYBhB7EiwA0d8oe2BX6H74XCV_TLwiFFvHAvCORFbwWoB6WtK6BkogksNw-xvYBJv-pBoCMXcQAvD_BwE\nUser Agent: Mozilla/5.0 (Linux; Android 9; Redmi S2) AppleWebKit/537.36\n(KHTML, like Gecko) Chrome/104.0.0.0 Mobile Safari/537.36\nRemote IP: 45.234.41.67\nPowered by: Elementor"

      email
    end

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains lead website a source name' do
      expect(parsed_email[:source][:name]).to eq('Website')
    end

    it 'contains name' do
      expect(parsed_email[:customer][:name]).to eq('Raphael Michelangelo')
    end

    it 'contains phone' do
      expect(parsed_email[:customer][:phone]).to eq('12997920040')
    end

    it 'contains email' do
      expect(parsed_email[:customer][:email]).to eq('')
    end

    it 'contains CPF' do
      expect(parsed_email[:customer][:cpf]).to eq('44489212306')
    end

    it 'contains link page' do
      expect(parsed_email[:product][:link]).to eq('https://hdfveiculos.com.br/lp-carro-novo/?gclid=CjwKCAjwx7GYBhB7EiwA0d8oe2BX6H74XCV_TLwiFFvHAvCORFbwWoB6WtK6BkogksNw-xvYBJv-pBoCMXcQAvD_BwE')
    end

    it 'contains message' do
      expect(parsed_email[:message]).to eq('Valor de entrada: R$ 500 - Possui CNH: Tô tirando')
    end

    it 'contains product name' do
      expect(parsed_email[:product][:name]).to eq('Celta')
    end
  end
end
