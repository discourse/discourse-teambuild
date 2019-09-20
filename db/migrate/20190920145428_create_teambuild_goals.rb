# frozen_string_literal: true

class CreateTeambuildGoals < ActiveRecord::Migration[5.2]
  def change
    create_table :teambuild_goals do |t|
      t.integer :user_id, null: false
      t.integer :goal_id, null: false
      t.timestamps null: false
    end

    add_index :teambuild_goals, [:user_id, :goal_id], unique: true
  end
end
