# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Token Refresh API', type: :request do
  path '/api/auth/refresh' do
    post 'Refresh access token' do
      tags 'Authentication'
      description 'Refresh JWT access token using refresh token'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :account_user, in: :body, schema: {
        type: :object,
        properties: {
          account_user: {
            type: :object,
            properties: {
              refresh_token: { type: :string }
            },
            required: ['refresh_token']
          }
        }
      }

      response '201', 'Token refreshed successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string },
            data: {
              type: :object,
              properties: {
                user: { type: :object },
                refresh_token: { type: :string }
              }
            }
          }
        run_test!
      end

      response '401', 'Invalid refresh token' do
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

