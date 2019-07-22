class JsonWebToken
  SECRET_KEY = ENV['JWT_SECRET'] || 'secret'

  class << self
    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, SECRET_KEY)
    end

    def decode(token)
      body = JWT.decode(token, SECRET_KEY)
      HashWithIndifferentAccess.new body
      rescue => e
      nil
    end
  end
end
