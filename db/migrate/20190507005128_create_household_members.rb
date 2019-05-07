class CreateHouseholdMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :household_members do |t|
      t.references :vita_client, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.datetime :birthdate
      t.string :full_time_student
      t.string :non_citizen
      t.string :disabled
      t.string :legally_blind

      t.timestamps
    end
  end
end
