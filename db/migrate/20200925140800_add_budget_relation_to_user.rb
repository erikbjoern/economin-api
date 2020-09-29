class AddBudgetRelationToUser < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :budget, foreign_key: true
  end
end
