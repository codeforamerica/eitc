class CreateSigningRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :signing_requests do |t|
      t.references :vita_client, foreign_key: true
      t.string :federal_signature
      t.string :federal_signature_spouse
      t.string :state_signature
      t.string :state_signature_spouse
      t.string :signature_ip
      t.datetime :signed_at
      t.string :email
      t.string :unique_key

      t.timestamps
    end
  end
end
