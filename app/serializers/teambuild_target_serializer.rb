# frozen_string_literal: true

class TeambuildTargetSerializer < ApplicationSerializer
  attributes(
    :id,
    :target_type_id,
    :name,
    :group_id,
    :group_name,
    :position,
  )

  has_many :members, serializer: BasicUserSerializer

  def group_name
    object.group.name
  end

  def include_group_name?
    object.group_id.present?
  end

  def members
    object.group.users
  end

  def include_members?
    !!@options[:include_members] && object.group_id.present?
  end
end
