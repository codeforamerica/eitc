class AddClaimedEitcToEitcEstimate < ActiveRecord::Migration[5.2]
  def change
    add_column :eitc_estimates, :claimed_eitc, :string, default: 'unset'
  end
end
