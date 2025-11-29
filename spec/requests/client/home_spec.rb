# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Client Home API', type: :request do
  path '/api/client/home' do
    get 'Get home page data' do
      tags 'Client Home'
      description 'Get home page data including featured products, categories, etc.'
      produces 'application/json'

      response '200', 'Home data retrieved successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string },
            data: {
              type: :object
            }
          }
        run_test!
      end
    end
  end
end

