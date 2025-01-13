# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tickets::New' do
  subject(:feedback) { response }

  let(:event) { create :event }
  let(:user)  { create :user }
  let(:path)  { new_event_ticket_path(event) }

  describe 'GET /events/:event_id/tickets/new' do
    context 'when user is not logged in' do
      before { get path }

      it { is_expected.to redirect_to new_user_session_path }

      it 'renders a login prompt after redirect' do
        follow_redirect!
        expect(feedback.body).to include('Log in')
      end
    end

    context 'when user is logged in' do
      before do
        sign_in user
        get path
      end

      it { is_expected.to have_http_status :ok }

      it 'renders the new ticket form' do
        expect(feedback.body).to include('<form')
        expect(feedback.body).to include('ticket[quantity]')
      end
    end
  end
end
