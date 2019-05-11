module Api
  module V1
    # Questions controller integrating with the stack exchange service
    class QuestionsController < ApplicationController
      def index
        questions_response = stack_exchange_service.get_questions
        render json: {
          questions: questions_response
        }, status: :ok

        # can be async, if redis is seeming to take time
        REDIS_CLIENT.set('questions_path'+query_params.to_s, JSON.dump(questions_response.parsed_response))
        rescue BadGatewayError, GatewayTimeoutError
          render json: { questions: JSON.parse(REDIS_CLIENT.get('questions_path'+query_params.to_s)) }, status: :ok
      end

      private

      def query_params
        params.permit(:sort, :order, :site, :page).to_h
      end

      def stack_exchange_service
        @stack_exchange_service ||= StackExchange.new(query_params)
      end
    end
  end
end
