class JwtRedisDenyList < ApplicationRecord
  include ResponseHandler

  def self.jwt_revoked?(payload, user)
    $redis.exists("jwt:#{payload['jti']}") == 1
  end

  def self.revoke_jwt(payload, user)
    if $redis.exists("jwt:#{payload['jti']}") == 1
      raise RevokedTokenError
    end
    $redis.set("jwt:#{payload['jti']}", "", ex: payload["exp"].to_i - Time.now.to_i)
  end
end
