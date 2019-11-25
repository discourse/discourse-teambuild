# frozen_string_literal: true

class TeambuildProgressSerializer < ApplicationSerializer
  attributes :id, :completed, :total
  has_many :teambuild_targets
  has_one :user, serializer: BasicUserSerializer

  def id
    user.id
  end

  def teambuild_targets
    object[:teambuild_targets]
  end

  def user
    object[:user]
  end

  def completed
    object[:completed]
  end

  def total
    teambuild_targets.size
  end

end
