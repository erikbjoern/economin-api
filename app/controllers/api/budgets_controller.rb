class Api::BudgetsController < ApplicationController
  before_action :validate_and_format_requested_date, only: :index

  def index
    budget = Budget.where(
      "start_date < ? AND end_date > ?", 
      @requested_date, @requested_date
    )[0]

    if budget != nil
      render json: SingleBudgetSerializer.new(budget)
    else
      case true
      when @requested_date == Date.today
        message = "You don't have any budget set currently"
      when @requested_date > Date.today
        message = "You don't have any budget set for #{@readable_date}"
      when @requested_date < Date.today
        message = "You didn't have any budget set for #{@readable_date}"
      end

      render json: { message: message }, status: 404
    end 
  end

  def create 
    budget = Budget.create(create_params)

    if budget.persisted?
      render json: SingleBudgetSerializer.new(budget)
    else
      render_error_message(budget.errors)
    end
  end

  private

  def validate_and_format_requested_date
    if params['requested_date'] == nil || params['requested_date'] == ""
      render json: { 
         message: "Please provide a date that's within the time period you are looking for." 
      }, status: 400

      return
    end

    @requested_date = Date.strptime(params['requested_date'], '%Y-%m-%d')
    @readable_date = @requested_date.strftime("%d %b, %Y")
  end

  def create_params 
    params.permit(:amount, :start_date, :end_date)
  end
end
