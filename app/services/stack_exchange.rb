# Service which communicates with stack exchange apis
class StackExchange
  def initialize(query_params)
    @query_params = query_params
  end

  def get_questions
    path = 'https://api.stackexchange.com/2.2/questions'
    response = send_request(lambda {
      HTTParty.get(
        path,
        options
      )
    }, path)
    raise BadGatewayError.new(gateway: 'stack overflow', path: path) if response.code >= 400

    response
  end

  private

  def options
    { query: @query_params, timeout: 5 } # timeout can be read from config
  end

  def send_request(request, path)
    request.call
  rescue Timeout::Error
    raise GatewayTimeoutError.new(gateway: 'stack overflow', path: path)
  end
end
