require 'sinatra'
require 'sinatra/multi_route'
require 'sinatra/activerecord'
require 'rack/oauth2'

require_relative 'lib/oauth2_token'

require_relative 'models/access_token'
require_relative 'models/refresh_token'
require_relative 'models/authorization_code'
require_relative 'models/client'
require_relative 'models/user'

configure do
  set :database, adapter: 'sqlite3', database: 'db.sqlite3'
end

route :get, :post, '/oauth/authorize' do
  @user = User.find(1)

  begin
    if request.post?
      _status, header, response = authorize_endpoint(:allow_approval).call(env)
    else
      _status, header, response = authorize_endpoint.call(env)
    end
  rescue Rack::OAuth2::Server::Authorize::BadRequest => e
    @error = e
    return erb :error
  end

  ['WWW-Authenticate'].each do |key|
    request.headers[key] = header[key] if header[key].present?
  end

  if response.redirect?
    redirect header['Location']
  else
    erb :authorize
  end
end

post '/oauth/token' do
  token_endpoint.call(env)
end

def authorize_endpoint(allow_approval = false)
  Rack::OAuth2::Server::Authorize.new do |req, res|
    @client = Client.find_by_identifier(req.client_id) || req.bad_request!
    res.redirect_uri = @redirect_uri = req.verify_redirect_uri!(@client.redirect_uri)
    if allow_approval
      if params[:approve]
        case req.response_type
        when :code
          authorization_code = @user.authorization_codes.create(client: @client,
                                                                redirect_uri: res.redirect_uri)
          authorization_code.save!
          res.code = authorization_code.token
        when :token
          res.access_token = @user.access_tokens.create(client: @client).to_bearer_token
        end

        res.approve!
      else
        req.access_denied!
      end
    else
      @response_type = req.response_type
    end
  end
end

def token_endpoint
  Rack::OAuth2::Server::Token.new do |req, res|
    client = Client.find_by_identifier(req.client_id) || req.invalid_client!
    client.secret == req.client_secret || req.invalid_client!
    case req.grant_type
    when :authorization_code
      code = AuthorizationCode.valid.find_by_token(req.code)
      req.invalid_grant! if code.blank? || code.redirect_uri != req.redirect_uri
      res.access_token = code.access_token.to_bearer_token(:with_refresh_token)
    when :password
      # NOTE: this example doesn't implement a password; you should do that.
      user = User.find_by username: req.username || req.invalid_grant!
      res.access_token = user.access_tokens.create(client: client).to_bearer_token(:with_refresh_token)
    when :client_credentials
      # NOTE: client is already authenticated here.
      res.access_token = client.access_tokens.create.to_bearer_token
    when :refresh_token
      refresh_token = client.refresh_tokens.valid.find_by_token(req.refresh_token)
      req.invalid_grant! unless refresh_token
      res.access_token = refresh_token.access_tokens.create.to_bearer_token
    else
      # NOTE: extended assertion grant_types are not supported yet.
      req.unsupported_grant_type!
    end
  end
end
