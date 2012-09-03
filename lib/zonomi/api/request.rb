module Zonomi::API

class Request

  REQUEST_METHOD = :get
  RESULT_KEY = 'dnsapi_result'

  attr_reader :params, :client, :response, :result

  def initialize(params = {})
    @params = params
    @client = @params.delete(:client)
    @request_path = @params.delete(:request_path)
    @response = nil
    @result = nil
    self
  end

  def send!
    request_params = [
      REQUEST_METHOD,
      path_for(*@request_path),
      { query: prepare(@params) }
    ]
    @response = self.client.class.send(*request_params)
    @result = Result.new(@response[RESULT_KEY])
    self
  end

  private

  def prepare(params)
    default_params.merge(params)
  end

  def default_params
    {
      api_key: self.client.api_key,
    }
  end

  def path_for(*api_type)
    path = api_type.reduce(SERVER[:routes]){ |a,i| a[i] }
    if path.nil? || path.is_a?(Hash)
      path = SERVER[:routes][:dyndns]
    end
    [
      path,
      SERVER[:suffix],
    ].join
  end

end

end
