class AddFullNameToResearchContact < ActiveRecord::Migration[5.2]
  def change
    add_column :research_contacts, :full_name, :string
  end
end
