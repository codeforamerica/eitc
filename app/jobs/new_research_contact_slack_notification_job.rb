class NewResearchContactSlackNotificationJob < ApplicationJob
  def perform(research_contact:)
    research_contact = ResearchContactDecorator.new(research_contact)
    SlackService.instance.post_to_workforce_alerts({
      text: "New research sign up!",
      attachments: [
        {
          title: research_contact.name_and_phone,
          text: research_contact.summary
        }
      ]})
  end
end