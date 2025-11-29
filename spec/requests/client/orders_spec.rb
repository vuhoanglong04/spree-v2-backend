# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Client Orders API', type: :request do
  path '/api/client/orders' do
    get 'List orders' do
      tags 'Client Orders'
      description 'Get all orders for the current user'
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

    post 'Create order' do
      tags 'Client Orders'
      description 'Create a new order'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :order, in: :body, schema: {
        type: :object,
        properties: {
          order: {
            type: :object,
            properties: {
              cart_item_ids: {
                type: :array,
                items: { type: :integer }
              },
              shipping_address: { type: :string },
              billing_address: { type: :string }
            }
          }
        }
      }

      response '201', 'Order created successfully' do
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

  path '/api/client/orders/{id}' do
    patch 'Update order' do
      tags 'Client Orders'
      description 'Update an existing order'
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
              status: { type: :string, example: 'cancelled' }
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

