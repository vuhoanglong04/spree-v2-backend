# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Payment API', type: :request do
  path '/api/payment/stripe' do
    post 'Create Stripe payment session' do
      tags 'Payment'
      description 'Create a Stripe checkout session for an order'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :payment, in: :body, schema: {
        type: :object,
        properties: {
          order_id: { type: :integer, example: 1 },
          items: {
            type: :array,
            items: {
              type: :object,
              properties: {
                stripe_price_id: { type: :string, example: 'price_1234567890' },
                quantity: { type: :integer, example: 2 }
              }
            }
          }
        },
        required: ['order_id', 'items']
      }

      response '200', 'Payment session created successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string },
            data: { type: :string, description: 'Stripe checkout URL' }
          }
        run_test!
      end

      response '422', 'Payment creation failed' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'fail' },
            message: { type: :string }
          }
        run_test!
      end
    end
  end

  path '/api/payment/repaid_stripe' do
    post 'Repay with Stripe' do
      tags 'Payment'
      description 'Create a Stripe checkout session for repaying an order'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :query, type: :integer, description: 'Order ID', example: 1

      response '200', 'Payment session created successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string },
            data: { type: :string, description: 'Stripe checkout URL' }
          }
        run_test!
      end
    end
  end

  path '/api/payment/stripe/web_hook' do
    post 'Stripe webhook' do
      tags 'Payment'
      description 'Handle Stripe webhook events'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :'X-Stripe-Signature', in: :header, type: :string, description: 'Stripe signature header'

      response '200', 'Webhook processed successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' }
          }
        run_test!
      end
    end
  end
end

