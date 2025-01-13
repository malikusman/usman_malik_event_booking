require 'rails_helper'

RSpec.describe Event do
  describe 'associations' do
    it { should belong_to :user }
  end

  describe 'validations' do
    # existing validations
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :location }
    it { should validate_presence_of :event_date }
    it { should validate_presence_of :event_time }

    it {
      should validate_numericality_of(:total_tickets)
        .only_integer
        .is_greater_than_or_equal_to(0)
    }
  end

  describe '.upcoming' do
    let!(:past_event) do
      create(:event, event_date: 1.day.ago.to_date, event_time: Time.current.change(hour: 9, min: 0) - 1.day)
    end

    let!(:future_event) do
      create(:event, event_date: 1.day.from_now.to_date, event_time: Time.current.change(hour: 9, min: 0) + 1.day)
    end

    it 'includes future events' do
      expect(described_class.upcoming).to include future_event
    end

    it 'excludes past events' do
      expect(described_class.upcoming).not_to include past_event
    end
  end
end
