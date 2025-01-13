# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Authentication', type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe 'GET /users/sign_in' do
    it 'renders the sign in page' do
      get new_user_session_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /users/sign_in' do
    context 'with valid credentials' do
      it 'logs the user in and redirects' do
        post user_session_path, params: { user: { email: user.email, password: user.password } }
        expect(response).to have_http_status(:redirect)
        follow_redirect!
        expect(response.body).to include('Signed in successfully')
      end
    end

    context 'with invalid credentials' do
      it 're-renders sign in form' do
        post user_session_path, params: { user: { email: user.email, password: 'wrong_password' } }
        expect(response.body).to include('Invalid Email or password')
      end
    end
  end
end
