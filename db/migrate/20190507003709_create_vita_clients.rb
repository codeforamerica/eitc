class CreateVitaClients < ActiveRecord::Migration[5.2]
  def change
    create_table :vita_clients do |t|
      t.string :phone_number
      t.string :email
      t.string :has_spouse
      t.string :why_cant_file_with_spouse
      t.string :anyone_self_employed
      t.string :anything_else
      t.string :signature

      t.timestamps
    end
  end
end
