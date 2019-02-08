class CreateResearchContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :research_contacts do |t|
      t.string :email
      t.string :phone_number
      t.string :visitor_id

      t.timestamps
    end
  end
end
