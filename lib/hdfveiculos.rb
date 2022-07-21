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
      parsed_email = @email.body.colons_to_hash(/(Nome|Telefone|Email|Data de Nascimento|Page URL|Nº do CPF:|Possui CNH?|Qual valor da entrada?).*?:/, false)
      source = F1SalesCustom::Email::Source.all[0]

      {
        source: {
          name: source[:name]
        },
        customer: {
          name: parsed_email['nome'],
          phone: parsed_email['telefone'],
          email: parsed_email['email'].split.first,
          cpf: parsed_email['n_do_cpf'].split.first
        },
        product: {
          link: parsed_email['page_url'].split.first,
          name: ''
        },
        message: "Valor de entrada: R$ #{parsed_email['qual_valor_da_entrada']} - Possui CNH: #{parsed_email['possui_cnh']}"
      }
    end
  end
end
