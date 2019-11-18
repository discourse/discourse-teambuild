# frozen_string_literal: true

require_dependency 'teambuild_target'
require_dependency 'teambuild_target_serializer'

module DiscourseTeambuild
  class TargetsController < ApplicationController

    requires_login
    before_action :ensure_enabled

    def index
      targets = TeambuildTarget.all
      render_serialized(
        targets,
        TeambuildTargetSerializer,
        rest_serializer: true,
        root: 'teambuild_targets',
        extras: { groups: Group.all }
      )
    end

    def create
      target = TeambuildTarget.create!(params[:teambuild_target].permit(:name, :target_type_id, :group_id))
      render_serialized(target, TeambuildTargetSerializer, rest_serializer: true)
    end

    def destroy
      TeambuildTarget.find_by(id: params[:id])&.destroy
      render json: success_json
    end

    def update
      target = TeambuildTarget.find_by(id: params[:id])
      raise Discourse::NotFound if target.blank?

      target.update!(params[:teambuild_target].permit(:name, :target_type_id, :group_id))
      render_serialized(target, TeambuildTargetSerializer, rest_serializer: true)
    end

    def swap_position
      target_position = TeambuildTarget.where(id: params[:id]).pluck_first(:position)
      other_position = TeambuildTarget.where(id: params[:other_id]).pluck_first(:position)
      raise Discourse::NotFound if target_position.nil? || other_position.nil?

      TeambuildTarget.transaction do
        TeambuildTarget.where(id: params[:id], position: target_position).update_all(position: other_position * -1)
        TeambuildTarget.where(id: params[:other_id], position: other_position).update_all(position: target_position)
        TeambuildTarget.where(id: params[:id], position: other_position * -1).update_all(position: other_position)
      end
      render json: success_json
    end

    protected

    def ensure_enabled
      raise Discourse::InvalidAccess.new unless SiteSetting.teambuild_enabled?
    end
  end
end
