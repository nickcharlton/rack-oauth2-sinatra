user = User.new name: 'joebloggs', email: 'jb@example.com'
user.save!

client = Client.new name: 'example', website: 'http://example.com/',
                    redirect_uri: 'http://localhost:4567/oauth/callback',
                    user: user
client.save!
