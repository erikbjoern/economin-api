FactoryBot.define do
  factory :budget do
    amount { 7000 }
    start_date { Budget.last ? Budget.last.end_date : Date.today }
    end_date { start_date + 30 }
  end
end
