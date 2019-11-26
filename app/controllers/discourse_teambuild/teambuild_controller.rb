# frozen_string_literal: true

require_dependency 'teambuild_target'
require_dependency 'teambuild_progress_serializer'

module DiscourseTeambuild
  class TeambuildController < ApplicationController

    requires_login
    before_action :ensure_can_access

    def index
      render json: success_json
    end

    def progress
      user = params[:username].present? ? fetch_user_from_params : current_user
      targets = TeambuildTarget.all

      completed = []

      progress = {
        user: user,
        teambuild_targets: TeambuildTarget.all,
        completed: completed
      }

      TeambuildTargetUser.where(user_id: user.id).each do |t|
        completed << "#{t.teambuild_target_id}:#{t.target_user_id}"
      end

      render_serialized(
        progress,
        TeambuildProgressSerializer,
        rest_serializer: true,
        include_users: true
      )
    end

    def scores
      results = DB.query(<<~SQL, group_name: SiteSetting.teambuild_access_group)
        SELECT u.id,
          u.username,
          u.username_lower,
          u.uploaded_avatar_id,
          COUNT(ttu.id) AS score,
          RANK() OVER (ORDER BY COUNT(ttu.id) DESC) AS rank
        FROM users AS u
        LEFT OUTER JOIN teambuild_target_users AS ttu ON ttu.user_id = u.id
        INNER JOIN group_users AS gu ON gu.user_id = u.id
        INNER JOIN groups AS g ON gu.group_id = g.id
        WHERE g.name = :group_name
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
      TeambuildTargetUser.create!(
        user_id: current_user.id,
        teambuild_target_id: params[:target_id].to_i,
        target_user_id: params[:user_id].to_i
      ) rescue ActiveRecord::RecordNotUnique
      render json: success_json
    end

    def undo
      TeambuildTargetUser.where(
        user_id: current_user.id,
        teambuild_target_id: params[:target_id].to_i,
        target_user_id: params[:user_id].to_i
      ).delete_all

      render json: success_json
    end

    protected

    def ensure_can_access
      raise Discourse::InvalidAccess.new unless SiteSetting.teambuild_enabled?

      return if current_user.staff?

      group = Group.find_by(name: SiteSetting.teambuild_access_group)
      if group.blank? || !group.group_users.where(user_id: current_user.id).exists?
        raise Discourse::InvalidAccess.new
      end
    end
  end
end
