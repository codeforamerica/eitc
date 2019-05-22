class AddReadyToSubmitDocsToVitaClient < ActiveRecord::Migration[5.2]
  def change
    add_column :vita_clients, :ready_to_submit_docs, :boolean
  end
end
