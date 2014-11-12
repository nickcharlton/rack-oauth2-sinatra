class AccessToken < ActiveRecord::Base
  include OAuth2Token
  self.default_lifetime = 10.minutes
  belongs_to :refresh_token

  def to_bearer_token(with_refresh_token = false)
    bearer_token = Rack::OAuth2::AccessToken::Bearer.new(
      access_token: token,
      expires_in: expires_in
    )
    if with_refresh_token
      bearer_token.refresh_token = create_refresh_token(
        account: account,
        client: client
      ).token
    end
    bearer_token
  end

  private

  def setup
    super
    if refresh_token
      self.account = refresh_token.account
      self.client = refresh_token.client
      self.expires_at = [expires_at, refresh_token.expires_at].min
    end
  end
end
