# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ticket, type: :model do
  describe 'associations' do
    it { should belong_to :user }
    it { should belong_to :event }
  end

  describe 'validations' do
    it { should validate_presence_of :quantity }

    it do
      should validate_numericality_of(:quantity)
        .only_integer
        .is_greater_than(0)
    end
  end
end
