# frozen_string_literal: true

module DiscourseTeambuild
  class TeambuildController < ApplicationController
    def index
      render json: success_json
    end

    def goals
      render json: success_json
    end
  end
end
