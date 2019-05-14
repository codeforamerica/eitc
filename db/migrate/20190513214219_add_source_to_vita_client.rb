class AddSourceToVitaClient < ActiveRecord::Migration[5.2]
  def change
    add_column :vita_clients, :source, :string
  end
end
