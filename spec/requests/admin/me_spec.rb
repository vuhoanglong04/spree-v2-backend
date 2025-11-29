# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Admin Me API', type: :request do
  path '/api/admin/me' do
    get 'Get current admin user' do
      tags 'Admin'
      description 'Get current authenticated admin user information'
      produces 'application/json'
      security [bearerAuth: []]

      response '200', 'Admin user retrieved successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string },
            data: {
              type: :object,
              properties: {
                user: { type: :object }
              }
            }
          }
        run_test!
      end

      response '401', 'Unauthorized' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'fail' },
            message: { type: :string }
          }
        run_test!
      end
    end
  end
end

