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

after_initialize do
  add_to_serializer(:current_user, :has_teambuild_access?) do
    return true if scope.is_admin?
    group = Group.find_by("lower(name) = ?", SiteSetting.teambuild_access_group.downcase)
    return true if group && GroupUser.where(user_id: scope.user.id, group_id: group.id).exists?
  end
end
