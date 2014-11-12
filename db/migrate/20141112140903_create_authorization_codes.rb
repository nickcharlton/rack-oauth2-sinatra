class CreateAuthorizationCodes < ActiveRecord::Migration
  def change
    create_table :authorization_codes do |t|
      t.string :token
      t.string :redirect_uri
      t.datetime :expires_at

      t.references :user
      t.references :client

      t.timestamps
    end
  end
end
