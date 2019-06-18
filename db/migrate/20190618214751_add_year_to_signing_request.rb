class AddYearToSigningRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :signing_requests, :year, :integer
  end
end
