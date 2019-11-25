# frozen_string_literal: true

class TeambuildTargetUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :teambuild_target
  belongs_to :teambuild_target_user, class_name: 'User'
end
