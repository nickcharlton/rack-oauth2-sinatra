class CreateRefreshTokens < ActiveRecord::Migration
  def change
    create_table :refresh_tokens do |t|
      t.string :token
      t.datetime :expires_at

      t.references :user
      t.references :client

      t.timestamps
    end
  end
end
