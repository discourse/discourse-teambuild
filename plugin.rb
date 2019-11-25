# frozen_string_literal: true

# name: discourse-teambuild
# about: Team Building Exercise for Discourse
# version: 0.0.1
# authors: Robin Ward
# url: https://github.com/discourse-org/discourse-teambuild

load File.expand_path('../lib/discourse_teambuild/engine.rb', __FILE__)

enabled_site_setting :teambuild_enabled

register_svg_icon "campground" if respond_to?(:register_svg_icon)
register_asset 'stylesheets/team-build.scss'

Discourse::Application.routes.append do
  mount ::DiscourseTeambuild::Engine, at: "/team-build"
end
