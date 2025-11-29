# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Admin Orders API', type: :request do
  path '/api/admin/orders' do
    get 'List orders' do
      tags 'Admin Orders'
      description 'Get all orders'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :page, in: :query, type: :integer, required: false, example: 1

      response '200', 'Orders retrieved successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string },
            data: {
              type: :object,
              properties: {
                orders: {
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

  path '/api/admin/orders/{id}' do
    patch 'Update order' do
      tags 'Admin Orders'
      description 'Update an order status'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :id, in: :path, type: :integer, description: 'Order ID', example: 1
      parameter name: :order, in: :body, schema: {
        type: :object,
        properties: {
          order: {
            type: :object,
            properties: {
              status: { type: :string, example: 'shipped' }
            }
          }
        }
      }

      response '200', 'Order updated successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string },
            data: {
              type: :object,
              properties: {
                order: { type: :object }
              }
            }
          }
        run_test!
      end
    end
  end
end

