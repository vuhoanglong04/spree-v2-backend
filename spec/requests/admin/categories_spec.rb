# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Admin Categories API', type: :request do
  path '/api/admin/categories' do
    get 'List categories' do
      tags 'Admin Categories'
      description 'Get all categories'
      produces 'application/json'
      security [bearerAuth: []]

      response '200', 'Categories retrieved successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string },
            data: {
              type: :object,
              properties: {
                categories: {
                  type: :array,
                  items: { type: :object }
                }
              }
            }
          }
        run_test!
      end
    end

    post 'Create category' do
      tags 'Admin Categories'
      description 'Create a new category'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :category, in: :body, schema: {
        type: :object,
        properties: {
          category: {
            type: :object,
            properties: {
              name: { type: :string, example: 'Category Name' },
              parent_id: { type: :integer, nullable: true }
            }
          }
        }
      }

      response '201', 'Category created successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string },
            data: {
              type: :object,
              properties: {
                category: { type: :object }
              }
            }
          }
        run_test!
      end
    end
  end

  path '/api/admin/categories/{id}' do
    patch 'Update category' do
      tags 'Admin Categories'
      description 'Update a category'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :id, in: :path, type: :integer, description: 'Category ID', example: 1
      parameter name: :category, in: :body, schema: {
        type: :object,
        properties: {
          category: {
            type: :object,
            properties: {
              name: { type: :string }
            }
          }
        }
      }

      response '200', 'Category updated successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string }
          }
        run_test!
      end
    end

    delete 'Delete category' do
      tags 'Admin Categories'
      description 'Soft delete a category'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :id, in: :path, type: :integer, description: 'Category ID', example: 1

      response '200', 'Category deleted successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string }
          }
        run_test!
      end
    end
  end

  path '/api/admin/categories/{id}/restore' do
    post 'Restore category' do
      tags 'Admin Categories'
      description 'Restore a soft-deleted category'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :id, in: :path, type: :integer, description: 'Category ID', example: 1

      response '200', 'Category restored successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string }
          }
        run_test!
      end
    end
  end

  path '/api/admin/categories/search/list' do
    get 'Search categories' do
      tags 'Admin Categories'
      description 'Search categories by query'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :query, in: :query, type: :string, required: false, description: 'Search query'

      response '200', 'Categories found' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string },
            data: {
              type: :object,
              properties: {
                categories: {
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
end

