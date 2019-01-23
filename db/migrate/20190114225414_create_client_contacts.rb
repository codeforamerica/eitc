class CreateClientContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :client_contacts do |t|
      t.string :email
      t.string :phone_number

      t.timestamps
    end
  end
end
