# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'User Registration API', type: :request do
  path '/api/auth' do
    post 'User registration' do
      tags 'Authentication'
      description 'Register a new user account'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :account_user, in: :body, schema: {
        type: :object,
        properties: {
          account_user: {
            type: :object,
            properties: {
              email: { type: :string, example: 'user@example.com' },
              password: { type: :string, example: 'password123' },
              password_confirmation: { type: :string, example: 'password123' }
            },
            required: ['email', 'password', 'password_confirmation']
          }
        }
      }

      response '201', 'User registered successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string },
            data: {
              type: :object,
              properties: {
                id: { type: :integer },
                email: { type: :string }
              }
            }
          }
        run_test!
      end

      response '422', 'Validation failed' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'fail' },
            message: { type: :string },
            errors: { type: :object }
          }
        run_test!
      end
    end
  end
end

