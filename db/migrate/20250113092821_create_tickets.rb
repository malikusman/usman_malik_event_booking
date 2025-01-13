# frozen_string_literal: true

class CreateTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :tickets do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 1

      t.timestamps
    end
  end
end
