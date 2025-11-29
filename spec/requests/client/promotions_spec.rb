# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Client Promotions API', type: :request do
  path '/api/client/promotions' do
    get 'Get active promotion' do
      tags 'Client Promotions'
      description 'Get the currently active promotion'
      produces 'application/json'

      response '200', 'Promotion retrieved successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string },
            data: {
              type: :object,
              properties: {
                promotion: { type: :object }
              }
            }
          }
        run_test!
      end
    end
  end
end

