# frozen_string_literal: true

module ::DiscourseTeambuild
  class Engine < ::Rails::Engine
    engine_name 'discourse_teambuild'
    isolate_namespace DiscourseTeambuild
  end
end
