# frozen_string_literal: true

require_dependency 'teambuild_goal'

module DiscourseTeambuild
  class TargetsController < ApplicationController

    requires_login
    before_action :ensure_enabled

    def index
      render json: { teambuild_targets: [] }
    end

    protected

    def ensure_enabled
      raise Discourse::InvalidAccess.new unless SiteSetting.teambuild_enabled?
    end
  end
end
