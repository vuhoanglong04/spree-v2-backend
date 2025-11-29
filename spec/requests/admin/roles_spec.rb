# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Admin Roles API', type: :request do
  path '/api/admin/roles' do
    get 'List roles' do
      tags 'Admin Roles'
      description 'Get all roles'
      produces 'application/json'
      security [bearerAuth: []]

      response '200', 'Roles retrieved successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string },
            data: {
              type: :object,
              properties: {
                roles: {
                  type: :array,
                  items: { type: :object }
                }
              }
            }
          }
        run_test!
      end
    end

    post 'Create role' do
      tags 'Admin Roles'
      description 'Create a new role'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :role, in: :body, schema: {
        type: :object,
        properties: {
          role: {
            type: :object,
            properties: {
              name: { type: :string, example: 'admin' }
            }
          }
        }
      }

      response '201', 'Role created successfully' do
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

  path '/api/admin/roles/{id}' do
    patch 'Update role' do
      tags 'Admin Roles'
      description 'Update a role'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :id, in: :path, type: :integer, description: 'Role ID', example: 1
      parameter name: :role, in: :body, schema: {
        type: :object,
        properties: {
          role: {
            type: :object,
            properties: {
              name: { type: :string }
            }
          }
        }
      }

      response '200', 'Role updated successfully' do
        schema type: :object,
          properties: {
            status: { type: :string, example: 'success' },
            message: { type: :string }
          }
        run_test!
      end
    end

    delete 'Delete role' do
      tags 'Admin Roles'
      description 'Delete a role'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :id, in: :path, type: :integer, description: 'Role ID', example: 1

      response '200', 'Role deleted successfully' do
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

