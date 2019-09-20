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

    def scores
      results = DB.query(<<~SQL)
        SELECT u.id, u.username, count(tgb.id) AS score
        FROM users AS u
        INNER JOIN teambuild_goals AS tgb ON tgb.user_id = u.id
        WHERE u.moderator OR u.admin
        GROUP BY u.id, u.name, u.username
        ORDER BY score, u.username
      SQL

      render json: { scores: results }
    end

    def complete
      TeambuildGoal.create!(user_id: current_user.id, goal_id: params[:goal_id])
      render json: success_json
    end

    def undo
      TeambuildGoal.where(user_id: current_user.id, goal_id: params[:goal_id]).delete_all
      render json: success_json
    end
  end
end
