class CreateEitcEstimates < ActiveRecord::Migration[5.2]
  def change
    create_table :eitc_estimates do |t|
      t.string :status
      t.integer :children
      t.integer :income

      t.timestamps
    end
  end
end
