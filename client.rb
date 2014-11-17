require 'sinatra'
require 'oauth2'

configure do
  set :client, OAuth2::Client.new('client_id',
                                  'client_secret',
                                  site: 'http://localhost:9292',
                                  authorize_url: '/oauth/authorize')
end

get '/' do
  redirect_uri = 'http://localhost:4567/oauth/callback'

  begin
    p settings.client.auth_code.authorize_url(redirect_uri: redirect_uri)
  rescue OAuth2::Error => e
    p e.description
  end
end

get '/oauth/callback' do
  redirect_uri = 'http://localhost:4567/oauth/callback'

  begin
    access_token = settings.client.auth_code.get_token(params[:code],
                                                       redirect_uri: redirect_uri)
  rescue OAuth2::Error => e
    return p e.message
  end

  access_token.token
end
