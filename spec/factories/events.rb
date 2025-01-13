# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    association :user
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    location { Faker::Address.city }
    event_date { Date.today + 7 }
    event_time { Time.current.change(min: 0, sec: 0) } # round to nearest hour
    total_tickets { 50 }
  end
end
