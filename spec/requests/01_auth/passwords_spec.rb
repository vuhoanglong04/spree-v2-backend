# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Password Reset API', type: :request do
  path '/api/auth/reset_password' do
    post 'Request password reset' do
      tags 'Authentication'
      description 'Send password reset email'
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

      response '200', 'Password reset email sent' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string }
          }
        run_test!
      end
    end

    patch 'Update password' do
      tags 'Authentication'
      description 'Reset password with token'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :account_user, in: :body, schema: {
        type: :object,
        properties: {
          account_user: {
            type: :object,
            properties: {
              reset_password_token: { type: :string },
              password: { type: :string, example: 'newpassword123' },
              password_confirmation: { type: :string, example: 'newpassword123' }
            },
            required: ['reset_password_token', 'password', 'password_confirmation']
          }
        }
      }

      response '200', 'Password reset successful' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string }
          }
        run_test!
      end
    end
  end

  path '/api/auth/check_reset_password_token' do
    post 'Check reset password token' do
      tags 'Authentication'
      description 'Validate reset password token'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :account_user, in: :body, schema: {
        type: :object,
        properties: {
          account_user: {
            type: :object,
            properties: {
              reset_password_token: { type: :string }
            },
            required: ['reset_password_token']
          }
        }
      }

      response '200', 'Token is valid' do
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

