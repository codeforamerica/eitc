class AddStateToVitaClient < ActiveRecord::Migration[5.2]
  def change
    add_column :vita_clients, :state, :string
  end
end
