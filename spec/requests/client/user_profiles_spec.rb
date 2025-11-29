# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Client User Profiles API', type: :request do
  path '/api/client/user_profiles' do
    get 'Get user profile' do
      tags 'Client User Profiles'
      description 'Get current user profile'
      produces 'application/json'
      security [bearerAuth: []]

      response '200', 'User profile retrieved successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string },
            data: {
              type: :object,
              properties: {
                user_profile: { type: :object }
              }
            }
          }
        run_test!
      end
    end

    patch 'Update user profile' do
      tags 'Client User Profiles'
      description 'Update current user profile'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :user_profile, in: :body, schema: {
        type: :object,
        properties: {
          user_profile: {
            type: :object,
            properties: {
              first_name: { type: :string, example: 'John' },
              last_name: { type: :string, example: 'Doe' },
              phone: { type: :string, example: '+1234567890' }
            }
          }
        }
      }

      response '200', 'User profile updated successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string },
            data: {
              type: :object,
              properties: {
                user_profile: { type: :object }
              }
            }
          }
        run_test!
      end
    end
  end
end

