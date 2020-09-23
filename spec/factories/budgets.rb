FactoryBot.define do
  factory :budget do
    amount { 7000 }
    start_date { Date.today }
    end_date { Date.today + 30 }
  end
end
