class AddVisitorIdToVitaClient < ActiveRecord::Migration[5.2]
  def change
    add_column :vita_clients, :visitor_id, :string
  end
end
