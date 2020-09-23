class Budget < ApplicationRecord
  validates_presence_of :amount, :start_date, :end_date

  
end
