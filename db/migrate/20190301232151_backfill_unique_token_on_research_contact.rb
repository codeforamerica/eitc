class BackfillUniqueTokenOnResearchContact < ActiveRecord::Migration[5.2]
  class ResearchContact < ApplicationRecord
  end
  def change
    ResearchContact.all.each do |research_contact|
      research_contact.update(unique_token: SecureRandom.urlsafe_base64(5))
    end
  end
end
