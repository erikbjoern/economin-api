class Budget < ApplicationRecord
  validates_presence_of :amount, :start_date, :end_date
  validate :start_date_cannot_be_before_last_budgets_end_date, :end_date_cannot_be_before_start_date
  belongs_to :user

  def start_date_cannot_be_before_last_budgets_end_date
    if Budget.last == self 
      last_budget = Budget.second_to_last
    else 
      last_budget = Budget.last
    end

    if last_budget != nil && start_date.present? && start_date < last_budget.end_date
      errors.add(:start_date, "can't be before last budget's end date, which is #{last_budget.end_date}")
    end
  end

  def end_date_cannot_be_before_start_date
    if end_date.present? && start_date.present? && end_date < start_date
      errors.add(:end_date, "can't be before start date")
    end
  end
end
