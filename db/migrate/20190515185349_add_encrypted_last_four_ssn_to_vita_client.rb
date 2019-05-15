class AddEncryptedLastFourSsnToVitaClient < ActiveRecord::Migration[5.2]
  def change
    add_column :vita_clients, :encrypted_last_four_ssn, :string
    add_column :vita_clients, :encrypted_last_four_ssn_iv, :string
    add_column :vita_clients, :encrypted_last_four_ssn_spouse, :string
    add_column :vita_clients, :encrypted_last_four_ssn_spouse_iv, :string
  end
end
