# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Admin Account Users API', type: :request do
  path '/api/admin/account_users' do
    get 'List account users' do
      tags 'Admin Account Users'
      description 'Get all account users'
      produces 'application/json'
      security [bearerAuth: []]

      response '200', 'Account users retrieved successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string },
            data: {
              type: :object,
              properties: {
                account_users: {
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

  path '/api/admin/account_users/{id}/role' do
    get 'Get user role' do
      tags 'Admin Account Users'
      description 'Get role information for a user'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :id, in: :path, type: :integer, description: 'User ID', example: 1

      response '200', 'User role retrieved successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string },
            data: {
              type: :object,
              properties: {
                role: { type: :object }
              }
            }
          }
        run_test!
      end
    end
  end
end

