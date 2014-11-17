# rack-oauth2-sinatra

This is a sample project that uses [Rack::OAuth2][lib], but with [Sinatra][]
rather than [Rails][]. It uses ActiveRecord (through [sinatra-activerecord][]),
but others would slot in easily.

It's inspired by the provided [rack-oauth2-sample][] project by the original
author.

## Usage

### Server

The server is a as bare bones a Sinatra application as possble:

```sh
$ bundle install
$ bundle exec rake db:migrate
$ bundle exec rake db:seed
$ bundle exec rackup
```

### Client

The server is also a barebones Sinatra application (but you need to get the
client_id and client_secret). It implements the "web flow", known as
`authentication_code`:

```sh
$ [bundle install]
$ bundle exec ruby app.rb
```

## Testing

TBD.

## Author

Copyright (c) Nick Charlton 2014. MIT Licenced.

[lib]: https://github.com/nov/rack-oauth2
[Sinatra]: http://sinatrarb.com
[Rails]: http://rubyonrails.org
[sinatra-activerecord]: https://github.com/janko-m/sinatra-activerecord
[rack-oauth2-sample]: https://github.com/nov/rack-oauth2-sample
