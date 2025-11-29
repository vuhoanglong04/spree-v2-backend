# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Admin Products API', type: :request do
  path '/api/admin/products' do
    get 'List products' do
      tags 'Admin Products'
      description 'Get all products (including deleted)'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :page, in: :query, type: :integer, required: false, example: 1
      parameter name: :per_page, in: :query, type: :integer, required: false, example: 5

      response '200', 'Products retrieved successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string },
            data: {
              type: :object,
              properties: {
                products: {
                  type: :array,
                  items: { type: :object }
                }
              }
            },
            meta: { type: :object }
          }
        run_test!
      end
    end

    post 'Create product' do
      tags 'Admin Products'
      description 'Create a new product'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          product: {
            type: :object,
            properties: {
              name: { type: :string, example: 'Product Name' },
              description: { type: :string },
              brand: { type: :string },
              product_images_attributes: { type: :object },
              product_variants_attributes: { type: :object }
            }
          }
        }
      }

      response '201', 'Product created successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string },
            data: {
              type: :object,
              properties: {
                product: { type: :object }
              }
            }
          }
        run_test!
      end
    end
  end

  path '/api/admin/products/{id}' do
    get 'Show product' do
      tags 'Admin Products'
      description 'Get a specific product'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :id, in: :path, type: :integer, description: 'Product ID', example: 1

      response '200', 'Product retrieved successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string },
            data: {
              type: :object,
              properties: {
                product: { type: :object }
              }
            }
          }
        run_test!
      end
    end

    patch 'Update product' do
      tags 'Admin Products'
      description 'Update a product'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :id, in: :path, type: :integer, description: 'Product ID', example: 1
      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          product: {
            type: :object,
            properties: {
              name: { type: :string },
              description: { type: :string }
            }
          }
        }
      }

      response '200', 'Product updated successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string },
            data: {
              type: :object,
              properties: {
                product: { type: :object }
              }
            }
          }
        run_test!
      end
    end

    delete 'Delete product' do
      tags 'Admin Products'
      description 'Soft delete a product'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :id, in: :path, type: :integer, description: 'Product ID', example: 1

      response '200', 'Product deleted successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string }
          }
        run_test!
      end
    end
  end

  path '/api/admin/products/{id}/restore' do
    post 'Restore product' do
      tags 'Admin Products'
      description 'Restore a soft-deleted product'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :id, in: :path, type: :integer, description: 'Product ID', example: 1

      response '200', 'Product restored successfully' do
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

