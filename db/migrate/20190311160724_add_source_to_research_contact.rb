class AddSourceToResearchContact < ActiveRecord::Migration[5.2]
  def change
    add_column :research_contacts, :source, :string
  end
end
