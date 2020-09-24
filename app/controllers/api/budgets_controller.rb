class Api::BudgetsController < ApplicationController
  before_action :validate_presence_of_containing_date, only: :index

  def index
    budget = Budget.where(
      "start_date < ? AND end_date > ?", 
      params['containing_date'], params['containing_date']
    )[0]

    if budget != nil
      render json: { budget: budget }, status: 200
    else
      render json: { 
         message: 'No budget could be found for the requested period' 
      }, status: 404
    end 
  end

  def create 
    budget = Budget.create(create_params)

    if budget.persisted?
      render json: { budget: budget }, status: 200
    else
      render_error_message(budget.errors)
    end
  end

  private

  def validate_presence_of_containing_date
    if params['containing_date'] == nil || params['containing_date'] == ""
      render json: { 
         message: "Please provide a date that's within the requested budget's time period, in the param 'containing_date'" 
      }, status: 400

      return
    end
  end

  def create_params 
    params.permit(:amount, :start_date, :end_date)
  end
end
