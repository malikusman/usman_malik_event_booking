# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tickets::Index' do
  subject(:feedback) { response }

  let(:event) { create :event }
  let(:user)  { create :user }
  let(:path)  { event_tickets_path event }

  describe 'GET /events/:event_id/tickets' do
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
        create_list(:ticket, 2, event:, user:)

        sign_in user
        get path
      end

      it { is_expected.to have_http_status :ok }

      it 'displays tickets for the event' do
        expect(feedback.body).to include(event.name)
      end
    end
  end
end
