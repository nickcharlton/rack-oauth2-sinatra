class RefreshToken < ActiveRecord::Base
  include OAuth2Token
  self.default_lifetime = 1.month

  has_many :access_tokens
end
