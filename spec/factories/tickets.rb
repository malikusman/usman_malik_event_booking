# frozen_string_literal: true

FactoryBot.define do
  factory :ticket do
    association :user
    association :event
    quantity { Faker::Number.between(from: 1, to: 10) }
  end
end
