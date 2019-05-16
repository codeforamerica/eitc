class AddReferrerToVitaClient < ActiveRecord::Migration[5.2]
  def change
    add_column :vita_clients, :referrer, :string
  end
end
