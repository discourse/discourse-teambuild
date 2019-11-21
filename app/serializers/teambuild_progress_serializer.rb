# frozen_string_literal: true

class TeambuildProgressSerializer < ApplicationSerializer
  attributes :id, :username
  has_many :teambuild_targets

  def username
    object[:username]
  end

  def id
    object[:username]
  end

  def teambuild_targets
    object[:teambuild_targets]
  end

end
