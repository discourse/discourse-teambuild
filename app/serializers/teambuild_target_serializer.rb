# frozen_string_literal: true

class TeambuildTargetSerializer < ApplicationSerializer
  attributes :id, :target_type_id, :name, :position
end
