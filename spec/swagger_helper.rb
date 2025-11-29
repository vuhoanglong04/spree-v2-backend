# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Spree V2 Backend API',
        version: 'v1',
        description: 'API documentation for Spree V2 Backend'
      },
      paths: {},
      servers: [
        {
          url: 'http://localhost:3000',
          description: 'Development server'
        }
      ],
      tags: [
        { name: 'Authentication', description: 'User authentication and authorization endpoints' },
        { name: 'Client Products', description: 'Product endpoints for clients' },
        { name: 'Client Cart', description: 'Shopping cart management' },
        { name: 'Client Orders', description: 'Order management for clients' },
        { name: 'Client Categories', description: 'Product categories' },
        { name: 'Client User Profiles', description: 'User profile management' },
        { name: 'Client Promotions', description: 'Promotion information' },
        { name: 'Client Home', description: 'Home page data' },
        { name: 'Client Product Attributes', description: 'Product attributes' },
        { name: 'Admin Products', description: 'Product management for admins' },
        { name: 'Admin Categories', description: 'Category management for admins' },
        { name: 'Admin Orders', description: 'Order management for admins' },
        { name: 'Admin Account Users', description: 'User account management' },
        { name: 'Admin Roles', description: 'Role management' },
        { name: 'Admin Promotions', description: 'Promotion management for admins' },
        { name: 'Admin', description: 'Admin user information' },
        { name: 'Payment', description: 'Payment processing endpoints' }
      ],
      components: {
        securitySchemes: {
          bearerAuth: {
            type: :http,
            scheme: :bearer,
            bearerFormat: 'JWT'
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml
end
