class AddYearsAlreadyFiledToVitaClient < ActiveRecord::Migration[5.2]
  def change
    add_column :vita_clients, :years_already_filed, :text, array: true, default: []
  end
end
