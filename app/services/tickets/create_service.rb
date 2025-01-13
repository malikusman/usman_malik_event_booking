# frozen_string_literal: true

module Tickets
  # Managing ticket creation and logic around it
  class CreateService
    def initialize(event, user, quantity)
      @event = event
      @user = user
      @quantity = quantity
    end

    def call
      ActiveRecord::Base.transaction do
        locked_event = Event.lock('FOR UPDATE').find(event.id)

        # Check if the event is in the past
        raise StandardError, 'Cannot book tickets for a past event.' if event_ended?(locked_event)

        # Check if total_tickets is zero
        raise ArgumentError, 'Event has 0 tickets total.' if locked_event.total_tickets.zero?

        # Check if there are enough tickets left
        already_booked = locked_event.tickets.sum(:quantity)
        remaining = locked_event.total_tickets - already_booked
        if quantity > remaining
          raise StandardError, "Not enough tickets. Requested: #{quantity}, Remaining: #{remaining}"
        end

        # Create the ticket
        locked_event.tickets.create!(user:, quantity:)
      end
    end

    private

    def event_ended?(locked_event)
      # # Its the requirement to keep date and time separate - we could have datetime
      event_start = locked_event.event_date.to_time.change(
        hour: locked_event.event_time.hour,
        min: locked_event.event_time.min,
        sec: locked_event.event_time.sec
      )
      event_start < Time.current
    end

    attr_reader :event, :user, :quantity
  end
end
