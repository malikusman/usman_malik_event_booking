# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Events::Index' do
  subject(:feedback) { response }

  let!(:past_event) do
    create(:event,
      event_date: 1.day.ago.to_date,
      event_time: Time.current.change(hour: 10, min: 0) - 1.day,
      name: 'Past Event')
  end

  let!(:future_event) do
    create(:event,
      event_date: 1.day.from_now.to_date,
      event_time: Time.current.change(hour: 10, min: 0) + 1.day,
      name: 'Future Event')
  end

  let(:path) { events_path }

  describe 'GET /events' do
    context 'when user is not logged in' do
      before { get path }

      it 'has status :ok' do
        expect(feedback).to have_http_status :ok
      end

      it 'does not list past events' do
        expect(feedback.body).not_to include('Past Event')
      end

      it 'lists future events' do
        expect(feedback.body).to include('Future Event')
      end
    end

    context 'when user is logged in' do
      let(:user) { create :user }

      before do
        sign_in user
        get path
      end

      it 'has status :ok' do
        expect(feedback).to have_http_status :ok
      end

      it 'does not list past events' do
        expect(feedback.body).not_to include('Past Event')
      end

      it 'lists future events' do
        expect(feedback.body).to include('Future Event')
      end
    end
  end
end
