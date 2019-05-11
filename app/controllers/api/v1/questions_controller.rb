module Api
  module V1
    # Questions controller integrating with the stack exchange service
    class QuestionsController < ApplicationController

      def index
        render json: {
          questions: stack_exchange_service.get_questions
        }, status: :ok
      end

      private

      def stack_exchange_service
        @stack_exchange_service ||= StackExchange.new
      end
    end
  end
end
