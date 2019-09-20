# frozen_string_literal: true

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
        completed: []
      }
    end
  end
end
