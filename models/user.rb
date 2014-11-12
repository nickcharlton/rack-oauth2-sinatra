class User < ActiveRecord::Base
  has_many :clients
  has_many :access_tokens
  has_many :authorization_codes
end
