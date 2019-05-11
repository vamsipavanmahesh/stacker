require 'spec_helper'
require 'rails_helper'

RSpec.describe StackExchange, type: :service do
  let(:query_params) { { 'foo' => 'foo', 'bar' => 'bar' } }


  describe 'get_questions' do
    it 'raises bad gateway error if response code is >= 400' do
      allow(HTTParty).to receive(:get)
        .with("https://api.stackexchange.com/2.2/questions", {query: query_params, timeout: 5})
        .and_return(double('Response', code: 400, :parsed_response => {error: { message: 'Too many requests'} }))

      expect{ described_class.new(query_params).get_questions }.to raise_error(BadGatewayError) 
    end

    it 'raises gateway timeout error if the request times out' do
      allow(HTTParty).to receive(:get)
        .with("https://api.stackexchange.com/2.2/questions", {query: query_params, timeout: 5})
        .and_raise(GatewayTimeoutError)

      expect{ described_class.new(query_params).get_questions }.to raise_error(GatewayTimeoutError) 
    end
  end
end
