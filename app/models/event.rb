# frozen_string_literal: true

# Event in the system. Each event is created by a user
class Event < ApplicationRecord
  belongs_to :user
  has_many :tickets, dependent: :destroy

  with_options presence: true do
    validates :name
    validates :description
    validates :location
    validates :event_date
    validates :event_time
  end

  # Assumption: Its 0 becasue there can be chance that user ois just creating an event so people can view
  validates :total_tickets,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Only show events whose date/time is in the future
  scope :upcoming, -> { where('(CAST(event_date AS timestamp) + event_time) >= ?', Time.current) }
end
