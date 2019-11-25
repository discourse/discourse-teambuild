# frozen_string_literal: true

class TeambuildTargetSerializer < ApplicationSerializer
  attributes(
    :id,
    :target_type_id,
    :name,
    :group_id,
    :group_name,
    :position
  )

  has_many :users, serializer: BasicUserSerializer

  def group_name
    object.group.name
  end

  def include_group_name?
    object.group_id.present?
  end

  def users
    object.group.users
  end

  def include_users?
    !!@options[:include_users] && object.group_id.present?
  end
end
