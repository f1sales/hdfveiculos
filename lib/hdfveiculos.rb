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
          email_id: 'website',
          name: 'Website'
        }
      ]
    end
  end
  class F1SalesCustom::Email::Parser
    def parse
      parsed_email = @email.body.colons_to_hash(/(Nome).*?:/, false)
      source = F1SalesCustom::Email::Source.all[0]
      
      {
        source: {
          name: source[:name]
        }
      }
    end
  end
end
