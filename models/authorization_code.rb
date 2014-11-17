class AuthorizationCode < ActiveRecord::Base
  include OAuth2Token

  def access_token
    @access_token ||= expired! && user.access_tokens.create(client: client)
  end
end
