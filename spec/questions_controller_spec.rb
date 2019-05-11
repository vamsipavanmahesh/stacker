require 'spec_helper'
require 'rails_helper'

RSpec.describe Api::V1::QuestionsController, type: :controller do
  describe "GET index" do
    it "reads from cache if service returns bad gateway" do
      REDIS_CLIENT.set("questions_path{\"sort\"=>\"foo\"}", JSON.dump({"foo": "bar"}))
      allow_any_instance_of(StackExchange).to receive(:get_questions).and_raise(BadGatewayError)
      get :index, format: :json, params: { 'sort' => 'foo' }
      expect(response.status).to eq 200
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['questions']['foo']).to eq 'bar'
    end
  end
end
