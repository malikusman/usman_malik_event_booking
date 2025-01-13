# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.string :location, null: false
      t.date :event_date, null: false
      t.time :event_time, null: false
      t.integer :total_tickets, default: 0, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
