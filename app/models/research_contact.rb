class ResearchContact < ApplicationRecord
  include ContactInfo

  validates_presence_of :full_name, message: "Make sure to provide a name."
end
