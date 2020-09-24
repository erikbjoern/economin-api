class Api::BudgetsController < ApplicationController
  def index
    if params['containing_date'] == nil || params['containing_date'] == ""
      render json: { message: "Please provide a date that's within the requested budget's time period, in the param 'containing_date'" }, 
                     status: 400
      return
    end

    budget = Budget.where("start_date < ? AND end_date > ?", params['containing_date'], params['containing_date'])[0]

    if budget != nil
      render json: { budget: budget }, status: 200
    else
      render json: { message: 'No budget could be found for the requested period' }, status: 404
    end 
  end

  def create 
    budget = Budget.create(amount: params['amount'], start_date: params['start_date'], end_date: params['end_date'])

    if budget.persisted?
      render json: { budget: budget }, status: 200
    else
      render_error_message(budget.errors)
    end
  end
end
