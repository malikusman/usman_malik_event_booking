# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Events::New' do
  subject(:feedback) { response }

  let(:path) { new_event_path }

  describe 'GET /events/new' do
    context 'when user is not logged in' do
      before { get path }

      it { is_expected.to redirect_to new_user_session_path }

      it 'shows an alert or redirect' do
        follow_redirect!
        expect(feedback.body).to include('Log in')
      end
    end

    context 'when user is logged in' do
      let(:user) { create :user }

      before do
        sign_in user
        get path
      end

      it { is_expected.to have_http_status :ok }

      it 'renders the new event form' do
        expect(feedback.body).to include('<form')
        expect(feedback.body).to include('event[name]')
      end
    end
  end
end
