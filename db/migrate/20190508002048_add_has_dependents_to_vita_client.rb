class AddHasDependentsToVitaClient < ActiveRecord::Migration[5.2]
  def change
    add_column :vita_clients, :has_dependents, :string
  end
end
