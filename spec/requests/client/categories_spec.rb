# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Client Categories API', type: :request do
  path '/api/client/categories' do
    get 'List categories' do
      tags 'Client Categories'
      description 'Get all categories'
      produces 'application/json'

      response '200', 'Categories retrieved successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string },
            data: {
              type: :object,
              properties: {
                categories: {
                  type: :array,
                  items: {
                    type: :object,
                    properties: {
                      id: { type: :integer },
                      name: { type: :string },
                      slug: { type: :string }
                    }
                  }
                }
              }
            }
          }
        run_test!
      end
    end
  end
end

