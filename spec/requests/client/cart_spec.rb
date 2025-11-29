# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Client Cart API', type: :request do
  path '/api/client/cart' do
    get 'List cart items' do
      tags 'Client Cart'
      description 'Get all items in the cart'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :page, in: :query, type: :integer, required: false, description: 'Page number', example: 1
      parameter name: :per_page, in: :query, type: :integer, required: false, description: 'Items per page', example: 5
      parameter name: :account_user_id, in: :query, type: :integer, required: true, description: 'User ID'

      response '200', 'Cart items retrieved successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string },
            data: {
              type: :object,
              properties: {
                cart_items: {
                  type: :array,
                  items: { type: :object }
                }
              }
            }
          }
        run_test!
      end
    end

    post 'Add item to cart' do
      tags 'Client Cart'
      description 'Add a product variant to the cart'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :cart_item, in: :body, schema: {
        type: :object,
        properties: {
          account_user_id: { type: :integer, example: 1 },
          product_variant_id: { type: :integer, example: 1 },
          quantity: { type: :integer, example: 2 }
        },
        required: ['account_user_id', 'product_variant_id', 'quantity']
      }

      response '201', 'Item added to cart successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string },
            data: {
              type: :object,
              properties: {
                cart_item: { type: :object }
              }
            }
          }
        run_test!
      end
    end

    patch 'Update cart items' do
      tags 'Client Cart'
      description 'Update multiple cart items (quantity or delete)'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :cart_items, in: :body, schema: {
        type: :object,
        properties: {
          cart_items: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer },
                quantity: { type: :integer },
                _destroy: { type: :boolean }
              }
            }
          }
        }
      }

      response '200', 'Cart updated successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string }
          }
        run_test!
      end
    end
  end

  path '/api/client/cart/{id}' do
    delete 'Remove item from cart' do
      tags 'Client Cart'
      description 'Remove a specific item from the cart'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :id, in: :path, type: :integer, description: 'Cart item ID', example: 1

      response '200', 'Item removed successfully' do
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

