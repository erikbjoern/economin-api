FactoryBot.define do
  factory :budget do
    amount { 7000 }
    start_date { Date.now() }
    end_date { Date.now() + Date.months(1) }
  end
end
