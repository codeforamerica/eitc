class AddAddressFieldsToVitaClient < ActiveRecord::Migration[5.2]
  def change
    add_column :vita_clients, :street_address, :string
    add_column :vita_clients, :city, :string
    add_column :vita_clients, :zip, :string
  end
end
