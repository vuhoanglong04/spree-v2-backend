# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Client Products API', type: :request do
  path '/api/client/products' do
    get 'List products' do
      tags 'Client Products'
      description 'Get a list of products with optional filtering and pagination'
      produces 'application/json'

      parameter name: :page, in: :query, type: :integer, required: false, description: 'Page number', example: 1
      parameter name: :query, in: :query, type: :string, required: false, description: 'Search query', example: 'laptop'
      parameter name: :min_price, in: :query, type: :number, required: false, description: 'Minimum price', example: 100
      parameter name: :max_price, in: :query, type: :number, required: false, description: 'Maximum price', example: 1000
      parameter name: :attribute_value_ids, in: :query, type: :array, items: { type: :integer }, required: false, description: 'Attribute value IDs', example: [1, 2]
      parameter name: :categories_ids, in: :query, type: :array, items: { type: :integer }, required: false, description: 'Category IDs', example: [1, 2]
      parameter name: :sort, in: :query, type: :string, required: false, description: 'Sort option', enum: ['price_asc', 'price_desc'], example: 'price_asc'

      response '200', 'Products retrieved successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string, example: 'Get all products successfully' },
            data: {
              type: :object,
              properties: {
                products: {
                  type: :array,
                  items: {
                    type: :object,
                    properties: {
                      id: { type: :integer },
                      name: { type: :string },
                      slug: { type: :string },
                      description: { type: :string },
                      brand: { type: :string },
                      created_at: { type: :string },
                      updated_at: { type: :string }
                    }
                  }
                }
              }
            },
            meta: {
              type: :object,
              properties: {
                current_page: { type: :integer },
                next_page: { type: :integer, nullable: true },
                prev_page: { type: :integer, nullable: true },
                total_pages: { type: :integer },
                total_count: { type: :integer },
                per_page: { type: :integer },
                is_first_page: { type: :boolean },
                is_last_page: { type: :boolean }
              }
            }
          }

        run_test!
      end
    end
  end

  path '/api/client/products/{id}' do
    get 'Show product' do
      tags 'Client Products'
      description 'Get a single product by slug'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string, description: 'Product slug', example: 'laptop-dell-xps-15'

      response '200', 'Product retrieved successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string, example: 'Get product successfully!' },
            data: {
              type: :object,
              properties: {
                product: {
                  type: :object,
                  properties: {
                    id: { type: :integer },
                    name: { type: :string },
                    slug: { type: :string },
                    description: { type: :string },
                    brand: { type: :string }
                  }
                },
                related_products: {
                  type: :array,
                  nullable: true,
                  items: {
                    type: :object
                  }
                }
              }
            }
          }

        let(:id) { 'test-product-slug' }
        run_test!
      end

      response '404', 'Product not found' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'fail' },
            message: { type: :string }
          }

        let(:id) { 'non-existent-slug' }
        run_test!
      end
    end
  end
end

