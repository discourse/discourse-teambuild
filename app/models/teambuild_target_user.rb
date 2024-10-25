# frozen_string_literal: true

class TeambuildTargetUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :teambuild_target
  belongs_to :teambuild_target_user, class_name: "User"
end

# == Schema Information
#
# Table name: teambuild_target_users
#
#  id                  :bigint           not null, primary key
#  user_id             :integer          not null
#  teambuild_target_id :bigint           not null
#  target_user_id      :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  teambuild_unique_choice  (user_id,teambuild_target_id,target_user_id) UNIQUE
#
