# frozen_string_literal: true

# name: discourse-teambuild
# about: Team Building Exercise for Discourse
# version: 0.0.1
# authors: Robin Ward
# url: https://github.com/discourse/discourse-teambuild
# transpile_js: true

load File.expand_path('../lib/discourse_teambuild/engine.rb', __FILE__)

enabled_site_setting :teambuild_enabled

register_svg_icon "campground" if respond_to?(:register_svg_icon)
register_asset 'stylesheets/team-build.scss'

Discourse::Application.routes.append do
  mount ::DiscourseTeambuild::Engine, at: "/team-build"
end

after_initialize do
  add_to_class(:guardian, :has_teambuild_access?) do
    return false unless SiteSetting.teambuild_enabled?
    return true if is_admin?
    @user.groups.where(name: SiteSetting.teambuild_access_group).exists?
  end

  add_to_serializer(:current_user, :can_access_teambuild) do
    object.guardian.has_teambuild_access?
  end
end
