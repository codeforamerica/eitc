class AddSignatureFieldsToVitaClient < ActiveRecord::Migration[5.2]
  def change
    add_column :vita_clients, :signed_at, :datetime
    add_column :vita_clients, :signature_ip, :string
    add_column :vita_clients, :spouse_signature, :string
  end
end
