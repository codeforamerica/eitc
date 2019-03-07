class AddFollowedInterviewLinkToResearchContact < ActiveRecord::Migration[5.2]
  def change
    add_column :research_contacts, :followed_interview_link, :datetime
  end
end
