# app/middleware/jwt_error_handler.rb
class JwtErrorHandler
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      @app.call(env)
    rescue JWT::DecodeError, JWT::ExpiredSignature => e
      json_response("Token invalid")
    rescue RevokedTokenError => e
      json_response(e.message)
    end
  end

  private

  def json_response(message)
    [
      401,
      { "Content-Type" => "application/json" },
      [ { status: "error", message: message }.to_json ]
    ]
  end
end
