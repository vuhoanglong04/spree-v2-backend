# frozen_string_literal: true

# Middleware to set a permissive Content Security Policy in development
# This allows Swagger UI and webpack:// source maps to work
class RemoveCspMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)
    
    # Set a very permissive CSP that allows everything including webpack://
    # This is safe for development only
    permissive_csp = "default-src * 'unsafe-inline' 'unsafe-eval' data: blob: webpack:; " \
                     "connect-src * webpack: ws: wss:; " \
                     "script-src * 'unsafe-inline' 'unsafe-eval' blob: data: webpack:; " \
                     "style-src * 'unsafe-inline' blob: data:; " \
                     "img-src * data: blob:; " \
                     "font-src * data:; " \
                     "frame-src *; " \
                     "object-src 'none';"
    
    # Replace any existing CSP with permissive one
    headers['Content-Security-Policy'] = permissive_csp
    headers.delete('Content-Security-Policy-Report-Only')
    headers.delete('X-Content-Security-Policy')
    headers.delete('X-WebKit-CSP')
    
    [status, headers, response]
  end
end

