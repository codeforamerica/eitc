class CreateReminderContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :reminder_contacts do |t|
      t.string :email
      t.string :phone_number

      t.timestamps
    end
  end
end
