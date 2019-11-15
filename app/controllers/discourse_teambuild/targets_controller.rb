# frozen_string_literal: true

require_dependency 'teambuild_target'
require_dependency 'teambuild_target_serializer'

module DiscourseTeambuild
  class TargetsController < ApplicationController

    requires_login
    before_action :ensure_enabled

    def index
      targets = TeambuildTarget.all
      render_serialized(targets, TeambuildTargetSerializer, rest_serializer: true, root: 'teambuild_targets')
    end

    def create
      target = TeambuildTarget.create!(params[:teambuild_target].permit(:name, :target_type_id, :group_id))
      render_serialized(target, TeambuildTargetSerializer, rest_serializer: true)
    end

    def destroy
      if target = TeambuildTarget.find_by(id: params[:id])
        target.destroy
      end
      render json: success_json
    end

    protected

    def ensure_enabled
      raise Discourse::InvalidAccess.new unless SiteSetting.teambuild_enabled?
    end
  end
end
