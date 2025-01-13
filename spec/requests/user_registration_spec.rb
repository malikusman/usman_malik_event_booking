# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Registration', type: :request do
  it 'allows a new user to sign up with first_name and last_name' do
    get new_user_registration_path
    expect(response).to have_http_status :ok

    post user_registration_path, params: {
      user: {
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: Faker::Internet.email,
        password: 'Password123',
        password_confirmation: 'Password123'
      }
    }
    follow_redirect!
    expect(response.body).to include('Welcome! You have signed up successfully.')
  end
end
