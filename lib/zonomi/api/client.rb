module Zonomi::API

class Client

  include HTTParty

  def self.server_base_uri
    [
      SERVER[:domain],
      SERVER[:prefix]
    ].join
  end

  base_uri self.server_base_uri
  format :xml

  attr_accessor :api_key
  attr_reader :api

  def initialize(*args)
    # options = args.extract_options!
    options = args.last.is_a?(::Hash) ? args.pop : {}
    @api_key = ! args[0].nil? ? args[0] : options.delete(:api_key) || ''
    @api = Adapter.new(self)
  end

  def api_request(params)
    Request.new(params.merge(client: self))
  end

  def valid?
    validate!
  end

  private

  def validate!
    ! @api_key.nil? && ( @api_key.is_a?(String) || @api_key.is_a?(Integer) ) && @api_key.size > 0
  end

end

end
