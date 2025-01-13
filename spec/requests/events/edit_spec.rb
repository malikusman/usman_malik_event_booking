# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Events::Edit' do
  subject(:feedback) { response }

  let(:owner) { create :user }
  let!(:event) { create(:event, user: owner) }
  let(:path) { edit_event_path(event) }

  describe 'GET /events/:id/edit' do
    context 'when user is not logged in' do
      before { get path }

      it { is_expected.to redirect_to new_user_session_path }
    end

    context 'when user is logged in but not owner' do
      let(:other_user) { create :user }

      before do
        sign_in other_user
        get path
      end

      it { is_expected.to redirect_to events_path }

      it 'shows an alert' do
        follow_redirect!
        expect(feedback.body).to include('You are not authorized')
      end
    end

    context 'when user is the owner' do
      before do
        sign_in owner
        get path
      end

      it { is_expected.to have_http_status :ok }

      it 'renders the edit form' do
        expect(feedback.body).to include('<form')
        expect(feedback.body).to include(event.name)
      end
    end
  end
end
