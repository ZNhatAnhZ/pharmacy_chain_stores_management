require "jwt"

class JsonWebToken
  ALGORITHM = "HS256".freeze

  class << self
    def encode payload
      JWT.encode(payload, "secret", ALGORITHM)
    end

    def decode token
      JWT.decode(token, "secret", true, {algorithm: ALGORITHM}).first
    end
  end
end
