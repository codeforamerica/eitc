class AddRelationToHouseholdMember < ActiveRecord::Migration[5.2]
  def change
    add_column :household_members, :relation, :string
  end
end
