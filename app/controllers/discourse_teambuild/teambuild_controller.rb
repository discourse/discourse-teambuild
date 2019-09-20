# frozen_string_literal: true

require_dependency 'teambuild_goal'

module DiscourseTeambuild
  class TeambuildController < ApplicationController
    def index
      render json: success_json
    end

    def goals
      goals = DiscourseTeambuild::Goals.all
      render json: {
        goals: goals,
        total: goals[:team_members].size + goals[:activities].size,
        completed: TeambuildGoal.where(user_id: current_user.id).pluck(:goal_id)
      }
    end

    def complete
      TeambuildGoal.create!(user_id: current_user.id, goal_id: params[:goal_id])
      render json: success_json
    end

    def undo
      render json: success_json
    end
  end
end
