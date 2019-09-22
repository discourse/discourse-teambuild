# frozen_string_literal: true

require_dependency 'teambuild_goal'

module DiscourseTeambuild
  class TeambuildController < ApplicationController
    def index
      render json: success_json
    end

    def goals
      user = params[:username].present? ?
        User.find_by(username_lower: params[:username].downcase) :
        current_user

      goals = DiscourseTeambuild::Goals.all
      render json: {
        username: user.username,
        goals: goals,
        total: goals[:team_members].size + goals[:activities].size,
        completed: TeambuildGoal.where(user_id: user.id).pluck(:goal_id),
        readonly: user.id != current_user.id
      }
    end

    def scores
      results = DB.query(<<~SQL)
        SELECT u.id,
          u.username,
          u.username_lower,
          u.uploaded_avatar_id,
          COUNT(tgb.id) AS score
        FROM users AS u
        INNER JOIN teambuild_goals AS tgb ON tgb.user_id = u.id
        WHERE u.moderator OR u.admin
        GROUP BY u.id, u.name, u.username, u.username_lower, u.uploaded_avatar_id
        ORDER BY score DESC, u.username
      SQL

      last_score = 1000
      rank = 0
      scores = results.map do |r|
        r.as_json.tap do |result|
          rank += 1 if r.score < last_score
          last_score = r.score
          result['trophy'] = true if rank == 1
          result['rank'] = rank
          result['me'] = r.id == current_user.id
          result['avatar_template'] = User.avatar_template(r.username_lower, r.uploaded_avatar_id)
          result.delete('uploaded_avatar_id')
        end
      end

      render json: { scores: scores }
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
