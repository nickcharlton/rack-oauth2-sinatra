class CreateAccessTokens < ActiveRecord::Migration
  def change
    create_table :access_tokens do |t|
      t.string :token
      t.datetime :expires_at

      t.references :user
      t.references :client
      t.references :refresh_token

      t.timestamps
    end
  end
end
