class AddSmsEnabledToVitaClient < ActiveRecord::Migration[5.2]
  def change
    add_column :vita_clients, :sms_enabled, :string
  end
end
