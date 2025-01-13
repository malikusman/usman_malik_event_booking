# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Events::Destroy' do
  subject(:feedback) { response }

  let(:owner) { create :user }
  let(:other_user) { create :user }
  let!(:event) { create(:event, user: owner) }
  let(:path) { event_path event }

  describe 'DELETE /events/:id' do
    let(:send_request) { delete path }

    context 'when user is not logged in' do
      before { send_request }

      it { is_expected.to redirect_to new_user_session_path }
    end

    context 'when user is logged in but not owner' do
      before do
        sign_in other_user
        send_request
      end

      it { is_expected.to redirect_to events_path }

      it 'shows an alert' do
        follow_redirect!
        expect(feedback.body).to include('not authorized')
      end
    end

    context 'when user is the owner' do
      before do
        sign_in owner
      end

      it 'deletes the event' do
        expect { send_request }.to change(Event, :count).by(-1)
      end

      it 'redirects to the events list with a notice' do
        send_request
        expect(feedback).to redirect_to(events_path)
      end
    end
  end
end
