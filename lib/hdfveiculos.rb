require_relative "hdfveiculos/version"
require "f1sales_custom/source"
require "f1sales_custom/parser"
require "f1sales_helpers"

module Hdfveiculos
  class Error < StandardError; end

  class F1SalesCustom::Email::Source
    def self.all
      [
        {
          email_id: 'contato',
          name: 'Website'
        }
      ]
    end
  end

  class F1SalesCustom::Email::Parser
    def parse
      # byebug
      parsed_email = @email.body.colons_to_hash(/(Nome|Telefone|Celular|Email|Data de Nascimento|Data de nascimento|Qual o veículo de interesse?|Page URL|CPF|Nº do CPF:|Possui CNH?|Qual valor da entrada?|Valor de entrada).*?:/, false)
      source = F1SalesCustom::Email::Source.all[0]

      {
        source: {
          name: source[:name]
        },
        customer: {
          name: parsed_email['nome'],
          phone: parsed_email['telefone'] || parsed_email['celular'],
          email: parsed_email['email']&.split&.first || '',
          cpf: parsed_email['n_do_cpf']&.split&.first || parsed_email['cpf']
        },
        product: {
          link: parsed_email['page_url']&.split&.first,
          name: parsed_email['qual_o_veculo_de_interesse'] || ''
        },
        message: "Valor de entrada: R$ #{parsed_email['qual_valor_da_entrada'] || parsed_email['valor_de_entrada']} - Possui CNH: #{parsed_email['possui_cnh']&.split("\n")&.first}"
      }
    end
  end
end
