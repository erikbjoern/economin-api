class Api::BudgetsController < ApplicationController
  def create 
    budget = Budget.create(amount: params['amount'], start_date: params['start_date'], end_date: params['end_date'])

    if budget.persisted?
      render json: {}, status: 200
    else
      render_error_message(budget.errors)
    end
  end
end
