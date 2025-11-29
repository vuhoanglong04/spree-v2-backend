# frozen_string_literal: true

# Middleware to disable Content Security Policy for Swagger UI routes
# This allows Swagger UI to make API requests without CSP violations
class DisableCspForSwagger
  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new(env)
    
    # Check if this is a Swagger UI route or API route being called from Swagger
    if request.path.start_with?('/api-docs') || 
       (request.path.start_with?('/api/') && env['HTTP_REFERER']&.include?('/api-docs'))
      status, headers, response = @app.call(env)
      
      # Remove ALL CSP headers for Swagger UI
      headers.delete('Content-Security-Policy')
      headers.delete('Content-Security-Policy-Report-Only')
      headers.delete('X-Content-Security-Policy')
      headers.delete('X-WebKit-CSP')
      
      # Also set a permissive CSP if removal doesn't work
      headers['Content-Security-Policy'] = "default-src * 'unsafe-inline' 'unsafe-eval' data: blob:; connect-src *;"
      
      [status, headers, response]
    else
      @app.call(env)
    end
  end
end

