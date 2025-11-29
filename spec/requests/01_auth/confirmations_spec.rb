# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Email Confirmation API', type: :request do
  path '/api/auth/confirm_email' do
    post 'Confirm email' do
      tags 'Authentication'
      description 'Confirm user email with token'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :account_user, in: :body, schema: {
        type: :object,
        properties: {
          account_user: {
            type: :object,
            properties: {
              confirmation_token: { type: :string }
            },
            required: ['confirmation_token']
          }
        }
      }

      response '200', 'Email confirmed successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string }
          }
        run_test!
      end
    end
  end

  path '/api/auth/resend_confirmation' do
    post 'Resend confirmation email' do
      tags 'Authentication'
      description 'Resend confirmation email'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :account_user, in: :body, schema: {
        type: :object,
        properties: {
          account_user: {
            type: :object,
            properties: {
              email: { type: :string, example: 'user@example.com' }
            },
            required: ['email']
          }
        }
      }

      response '200', 'Confirmation email sent' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string }
          }
        run_test!
      end
    end
  end
end

