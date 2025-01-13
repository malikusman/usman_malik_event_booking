# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tickets::Create' do
  subject(:feedback) { response }

  let(:event) { create(:event, total_tickets: 5) }
  let(:user)  { create :user }
  let(:path)  { event_tickets_path(event) }

  describe 'POST /events/:event_id/tickets' do
    context 'when user is not logged in' do
      before do
        post path, params: { ticket: { quantity: 2 } }
      end

      it { is_expected.to redirect_to new_user_session_path }
    end

    context 'when user is logged in' do
      before do
        sign_in user
      end

      context 'with valid quantity' do
        it 'creates a new ticket via the service' do
          expect do
            post path, params: { ticket: { quantity: 2 } }
          end.to change(Ticket, :count).by(1)
        end

        it 'redirects to event_tickets_path with a success notice' do
          post path, params: { ticket: { quantity: 2 } }
          expect(feedback).to redirect_to(event_tickets_path(event))
        end
      end

      context 'with invalid quantity' do
        before do
          post path, params: { ticket: { quantity: 99_999 } }
        end

        it 'does not create a new ticket' do
          expect(Ticket.count).to eq 0
        end

        it { is_expected.to have_http_status(422) }

        it 'renders an alert message' do
          expect(feedback.body).to include('Not enough tickets')
        end
      end
    end
  end
end
