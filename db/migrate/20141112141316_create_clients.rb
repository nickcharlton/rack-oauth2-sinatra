class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :identifier
      t.string :secret
      t.string :name
      t.string :website
      t.string :redirect_uri

      t.references :user

      t.timestamps
    end
  end
end
