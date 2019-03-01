class AddUniqueIndexToResearchContact < ActiveRecord::Migration[5.2]
  def change
    add_index :research_contacts, :unique_token, unique: true
  end
end
