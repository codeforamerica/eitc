class AddVisitorIdToEitcEstimate < ActiveRecord::Migration[5.2]
  def change
    add_column :eitc_estimates, :visitor_id, :string
  end
end
