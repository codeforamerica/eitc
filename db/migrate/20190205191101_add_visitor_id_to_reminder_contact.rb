class AddVisitorIdToReminderContact < ActiveRecord::Migration[5.2]
  def change
    add_column :reminder_contacts, :visitor_id, :string
  end
end
