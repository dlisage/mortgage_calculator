# frozen_string_literal: true

# CreateInterestRates class
class CreateInterestRates < ActiveRecord::Migration[5.2]
  def change
    create_table :interest_rates do |t|
      t.decimal :interest_rate, precision: 14, scale: 6, default: 0
      t.integer :lock_version, default: 0, null: false
      t.timestamps
    end
  end
end
