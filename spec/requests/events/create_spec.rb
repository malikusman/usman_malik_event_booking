# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Events::Create' do
  subject(:feedback) { response }

  let(:path) { events_path }

  describe 'POST /events' do
    context 'when user is not logged in' do
      let(:send_request) { post path, params: { event: attributes_for(:event) } }

      it 'redirects to sign in' do
        send_request
        expect(feedback).to redirect_to new_user_session_path
      end
    end

    context 'when user is logged in' do
      let(:user) { create :user }
      let(:valid_params) { attributes_for(:event, name: 'Sample Event') }
      let(:invalid_params) { { name: '' } }

      before { sign_in user }

      context 'with valid params' do
        it 'creates a new event' do
          expect do
            post path, params: { event: valid_params }
          end.to change(Event, :count).by(1)
        end

        it 'redirects to the newly created event' do
          post path, params: { event: valid_params }
          expect(feedback).to redirect_to(Event.last)
        end
      end

      context 'with invalid params' do
        before { post path, params: { event: invalid_params } }

        it { is_expected.to have_http_status(422) }

        it 'renders errors in the response body' do
          expect(feedback.body).to include('can&#39;t be blank') # TODO: error in let.
        end
      end
    end
  end
end
