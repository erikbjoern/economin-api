class SingleBudgetSerializer < Jserializer::Base
  root :budget
  attributes :id, :amount, :start_date, :end_date
end