class AddUniqueTokenToResearchContact < ActiveRecord::Migration[5.2]
  def change
    add_column :research_contacts, :unique_token, :string
  end
end
