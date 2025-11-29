# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Authentication API', type: :request do
  path '/api/auth/sign_in' do
    post 'User login' do
      tags 'Authentication'
      description 'Authenticate a user and return JWT tokens'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :account_user, in: :body, schema: {
        type: :object,
        properties: {
          account_user: {
            type: :object,
            properties: {
              email: { type: :string, example: 'user@example.com' },
              password: { type: :string, example: 'password123' }
            },
            required: ['email', 'password']
          }
        }
      }

      response '201', 'Login successful' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string, example: 'Login successful' },
            data: {
              type: :object,
              properties: {
                user: {
                  type: :object,
                  properties: {
                    id: { type: :integer },
                    email: { type: :string },
                    created_at: { type: :string },
                    updated_at: { type: :string }
                  }
                },
                refresh_token: { type: :string }
              }
            }
          }

        let(:account_user) { { account_user: { email: 'test@example.com', password: 'password123' } } }
        run_test!
      end

      response '401', 'Authentication failed' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'fail' },
            message: { type: :string },
            errors: { type: :string }
          }

        let(:account_user) { { account_user: { email: 'wrong@example.com', password: 'wrong' } } }
        run_test!
      end
    end
  end

  path '/api/auth/sign_out' do
    post 'User logout' do
      tags 'Authentication'
      description 'Logout a user and revoke tokens'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :account_user, in: :body, schema: {
        type: :object,
        properties: {
          account_user: {
            type: :object,
            properties: {
              refresh_token: { type: :string }
            }
          }
        }
      }

      response '200', 'Logout successful' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string, example: 'Logged out successfully' }
          }

        let(:account_user) { { account_user: { refresh_token: 'token' } } }
        run_test!
      end
    end
  end
end

