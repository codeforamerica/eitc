class AddAppointmentUrlToResearchContact < ActiveRecord::Migration[5.2]
  def change
    add_column :research_contacts, :appointment_url, :string
  end
end
