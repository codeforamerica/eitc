class AddFiledRecentlyToEitcEstimate < ActiveRecord::Migration[5.2]
  def change
    add_column :eitc_estimates, :filed_recently, :string, default: 'unset'
  end
end
