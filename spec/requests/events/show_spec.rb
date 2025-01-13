# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Events::Show' do
  subject(:feedback) { response }

  let(:event) { create :event }
  let(:path) { event_path(event) }

  describe 'GET /events/:id' do
    before { get path }

    it { is_expected.to have_http_status :ok }

    it 'shows the event details' do
      expect(feedback.body).to include(event.name)
      expect(feedback.body).to include(event.description)
    end
  end
end
