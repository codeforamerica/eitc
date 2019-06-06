class AddAlreadyFiledNeedsToVitaClient < ActiveRecord::Migration[5.2]
  def change
    add_column :vita_clients, :already_filed_needs, :text
  end
end
