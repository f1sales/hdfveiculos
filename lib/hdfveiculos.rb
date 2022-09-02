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
      {
        source: source,
        customer: customer,
        product: product,
        message: lead_message
      }
    end

    def parsed_email
      @email.body.colons_to_hash(/(#{regular_expression}).*?:/, false)
    end

    def regular_expression
      'Nome|Telefone|Celular|Email|Data de Nascimento|Data de nascimento|
      |Qual o veículo de interesse?|Page URL|CPF|Nº do CPF:|Possui CNH?|Qual valor da entrada?|Valor de entrada'
    end

    def source
      {
        name: F1SalesCustom::Email::Source.all[0][:name]
      }
    end

    def customer
      {
        name: customer_name,
        phone: customer_phone,
        email: customer_email,
        cpf: customer_cpf
      }
    end

    def customer_name
      parsed_email['nome']
    end

    def customer_phone
      parsed_email['telefone'] || parsed_email['celular']
    end

    def customer_email
      parsed_email['email']&.split&.first || ''
    end

    def customer_cpf
      parsed_email['n_do_cpf']&.split&.first || parsed_email['cpf']
    end

    def product
      {
        link: product_link,
        name: product_name
      }
    end

    def product_link
      parsed_email['page_url']&.split&.first
    end

    def product_name
      parsed_email['qual_o_veculo_de_interesse'] || ''
    end

    def lead_message
      "Valor de entrada: R$ #{entry_value} - Possui CNH: #{customer_cnh}"
    end

    def entry_value
      parsed_email['qual_valor_da_entrada'] || parsed_email['valor_de_entrada']
    end

    def customer_cnh
      parsed_email['possui_cnh']&.split("\n")&.first
    end
  end
end
