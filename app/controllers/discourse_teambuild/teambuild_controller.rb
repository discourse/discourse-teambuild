# frozen_string_literal: true

require_dependency 'teambuild_target'
require_dependency 'teambuild_progress_serializer'

module DiscourseTeambuild
  class TeambuildController < ApplicationController

    requires_login
    before_action :ensure_enabled

    def index
      render json: success_json
    end

    def progress
      user = params[:username].present? ? fetch_user_from_params : current_user
      targets = TeambuildTarget.all
      progress = {
        username: user.username,
        teambuild_targets: TeambuildTarget.all
      }

      render_serialized(
        progress,
        TeambuildProgressSerializer,
        rest_serializer: true,
        include_members: true
      )
      # old stuff
      # goals = DiscourseTeambuild::Goals.all
      # render json: {
      #   username: user.username,
      #   teambuild_goals: [],
      #   goals: goals,
      #   total: goals[:team_members].size + goals[:activities].size,
      #   completed: TeambuildGoal.where(user_id: user.id).pluck(:goal_id),
      #   readonly: user.id != current_user.id
      # }

    end

    def scores
      results = DB.query(<<~SQL)
        SELECT u.id,
          u.username,
          u.username_lower,
          u.uploaded_avatar_id,
          COUNT(tgb.id) AS score,
          RANK() OVER (ORDER BY COUNT(tgb.id) DESC) AS rank
        FROM users AS u
        INNER JOIN teambuild_goals AS tgb ON tgb.user_id = u.id
        WHERE u.moderator OR u.admin
        GROUP BY u.id, u.name, u.username, u.username_lower, u.uploaded_avatar_id
        ORDER BY score DESC, u.username
      SQL

      scores = results.map do |r|
        r.as_json.tap do |result|
          result['trophy'] = true if r.rank == 1
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

    protected

    def ensure_enabled
      raise Discourse::InvalidAccess.new unless SiteSetting.teambuild_enabled?
    end
  end
end
