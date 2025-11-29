# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Admin Promotions API', type: :request do
  path '/api/admin/promotions' do
    get 'List promotions' do
      tags 'Admin Promotions'
      description 'Get all promotions'
      produces 'application/json'
      security [bearerAuth: []]

      response '200', 'Promotions retrieved successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string },
            data: {
              type: :object,
              properties: {
                promotions: {
                  type: :array,
                  items: { type: :object }
                }
              }
            }
          }
        run_test!
      end
    end

    post 'Create promotion' do
      tags 'Admin Promotions'
      description 'Create a new promotion'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :promotion, in: :body, schema: {
        type: :object,
        properties: {
          promotion: {
            type: :object,
            properties: {
              name: { type: :string, example: 'Summer Sale' },
              discount_percentage: { type: :number, example: 20.0 }
            }
          }
        }
      }

      response '201', 'Promotion created successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string },
            data: {
              type: :object,
              properties: {
                promotion: { type: :object }
              }
            }
          }
        run_test!
      end
    end
  end

  path '/api/admin/promotions/{id}' do
    patch 'Update promotion' do
      tags 'Admin Promotions'
      description 'Update a promotion'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :id, in: :path, type: :integer, description: 'Promotion ID', example: 1
      parameter name: :promotion, in: :body, schema: {
        type: :object,
        properties: {
          promotion: {
            type: :object,
            properties: {
              name: { type: :string },
              discount_percentage: { type: :number }
            }
          }
        }
      }

      response '200', 'Promotion updated successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string }
          }
        run_test!
      end
    end

    delete 'Delete promotion' do
      tags 'Admin Promotions'
      description 'Soft delete a promotion'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :id, in: :path, type: :integer, description: 'Promotion ID', example: 1

      response '200', 'Promotion deleted successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string }
          }
        run_test!
      end
    end
  end

  path '/api/admin/promotions/{id}/restore' do
    post 'Restore promotion' do
      tags 'Admin Promotions'
      description 'Restore a soft-deleted promotion'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :id, in: :path, type: :integer, description: 'Promotion ID', example: 1

      response '200', 'Promotion restored successfully' do
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

