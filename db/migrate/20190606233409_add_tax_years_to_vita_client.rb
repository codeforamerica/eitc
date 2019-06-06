class AddTaxYearsToVitaClient < ActiveRecord::Migration[5.2]
  def change
    add_column :vita_clients, :tax_years, :text, array: true, default: []
  end
end
