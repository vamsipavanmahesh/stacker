# Service which communicates with stack exchange apis
class StackExchange
  def initialize(query_params)
    @query_params = query_params
  end

  def get_questions
    path = 'https://api.stackexchange.com/2.2/questions'
    send_request(lambda {
      HTTParty.get(
        path,
        options
      ) # timeout can be read from config
    }, path)
  end

  private

  def options
    { query: @query_params, timeout: 5 }
  end

  def send_request(request, path)
    request.call
  rescue Timeout::Error
    raise GatewayTimeoutError.new(gateway: 'stack overflow', path: path)
  end
end
