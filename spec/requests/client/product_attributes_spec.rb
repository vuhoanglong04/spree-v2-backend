# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Client Product Attributes API', type: :request do
  path '/api/client/product_attributes' do
    get 'List product attributes' do
      tags 'Client Product Attributes'
      description 'Get all product attributes'
      produces 'application/json'

      response '200', 'Product attributes retrieved successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string },
            data: {
              type: :object,
              properties: {
                product_attributes: {
                  type: :array,
                  items: { type: :object }
                }
              }
            }
          }
        run_test!
      end
    end
  end
end

