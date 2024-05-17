# frozen_string_literal: true

module ::DiscourseTeambuild
  PLUGIN_NAME = "discourse-teambuild"

  class Engine < ::Rails::Engine
    engine_name PLUGIN_NAME
    isolate_namespace DiscourseTeambuild
  end
end
