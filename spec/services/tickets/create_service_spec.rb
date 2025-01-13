# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tickets::CreateService do
  subject(:service) { described_class.new(event, user, quantity) }

  let(:user) { create :user }
  let(:event) { create :event, total_tickets: 5 }
  let(:quantity) { 2 }

  describe '#call' do
    context 'when event has enough tickets' do
      it 'creates the ticket' do
        expect { service.call }.to change(Ticket, :count).by(1)
      end

      it 'does not raise any error' do
        expect { service.call }.not_to raise_error
      end
    end

    context 'when event has no tickets' do
      before { event.update!(total_tickets: 0) }

      it 'raises ArgumentError' do
        expect { service.call }.to raise_error(ArgumentError, 'Event has 0 tickets total.')
      end
    end

    context 'when requested quantity is more than remaining' do
      before do
        # create existing ticket so that only 1 ticket remains
        event.tickets.create!(user: create(:user), quantity: 4)
      end

      it 'raises StandardError about "Not enough tickets"' do
        expect { service.call }.to raise_error(StandardError, /Not enough tickets/)
      end

      it 'does not create any new ticket' do
        expect { service.call rescue nil }.not_to change(Ticket, :count)
      end
    end

    context 'when multiple threads try to book ticket simultaneously' do
      # We can think of threads and other way of testing this but i think for this assignment its sufficent.
      it 'prevents overselling' do
        described_class.new(event, create(:user), 4).call

        expect do
          described_class.new(event, user, 2).call
        end.to raise_error(StandardError, /Not enough tickets/)
      end
    end

    context 'when the event is in the past' do
      let(:yesterday) { 1.day.ago }

      before do
        # Adjust the event's date/time to be in the past
        event.update!(
          event_date: yesterday.to_date,
          event_time: yesterday.to_time.change(hour: 9, min: 0)
        )
      end

      it 'raises StandardError about booking for a past event' do
        expect { service.call }
          .to raise_error(StandardError, /Cannot book tickets for a past event/)
      end

      it 'does not create a new ticket' do
        expect { service.call rescue nil }.not_to change(Ticket, :count)
      end
    end
  end
end
