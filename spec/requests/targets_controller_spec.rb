# frozen_string_literal: true

require "rails_helper"

RSpec.describe DiscourseTeambuild::TargetsController do
  it "returns 404 when anonymous" do
    SiteSetting.teambuild_enabled = true
    get "/team-build/targets.json"
    expect(response.code).to eq("404")
  end

  it "returns 404 when not staff" do
    SiteSetting.teambuild_enabled = true
    sign_in(Fabricate(:user))
    get "/team-build/targets.json"
    expect(response.code).to eq("404")
  end

  context "when logged in" do
    fab!(:user) { Fabricate(:moderator) }

    before do
      SiteSetting.teambuild_enabled = true
      sign_in(user)
    end

    context "when enabled/disabled" do
      fab!(:target) do
        TeambuildTarget.create!(
          target_type_id: TeambuildTarget.target_types[:regular],
          name: "cool",
        )
      end

      it "returns 404 when disabled" do
        SiteSetting.teambuild_enabled = false
        get "/team-build/targets.json"
        expect(response.code).to eq("404")
      end

      it "returns json" do
        get "/team-build/targets.json"
        expect(response.code).to eq("200")
        json = JSON.parse(response.body)
        expect(json).to be_present
        json_target = json["teambuild_targets"].find { |t| t["id"] == target.id }

        expect(json_target).to be_present
        expect(json_target["name"]).to eq(target.name)
        expect(json_target["target_type_id"]).to eq(target.target_type_id)
      end

      it "creates the object" do
        post "/team-build/targets.json",
             params: {
               teambuild_target: {
                 name: "cool target name",
                 target_type_id: TeambuildTarget.target_types[:regular],
               },
             }
        expect(response.code).to eq("200")
        json = JSON.parse(response.body)
        expect(json).to be_present
        expect(json["teambuild_target"]).to be_present
        expect(json["teambuild_target"]["name"]).to eq("cool target name")
        t = TeambuildTarget.find_by(id: json["teambuild_target"]["id"])
        expect(t).to be_present
      end

      it "returns an error if group is missing" do
        post "/team-build/targets.json",
             params: {
               teambuild_target: {
                 name: "missing group",
                 target_type_id: TeambuildTarget.target_types[:user_group],
               },
             }
        expect(response.code).to eq("422")
      end

      it "creates the object with a group" do
        group_id = Group.pick(:id)
        post "/team-build/targets.json",
             params: {
               teambuild_target: {
                 name: "cool target name",
                 target_type_id: TeambuildTarget.target_types[:user_group],
                 group_id: group_id,
               },
             }
        expect(response.code).to eq("200")
        json = JSON.parse(response.body)
        expect(json).to be_present
        expect(json["teambuild_target"]).to be_present
        expect(json["teambuild_target"]["name"]).to eq("cool target name")
        expect(json["teambuild_target"]["group_id"]).to eq(group_id)
      end

      it "destroys the object" do
        id = target.id
        TeambuildTargetUser.create!(
          user_id: user.id,
          teambuild_target_id: id,
          target_user_id: user.id,
        )
        delete "/team-build/targets/#{id}.json"
        expect(response.code).to eq("200")
        expect(TeambuildTarget.find_by(id: id)).to be_blank
        expect(TeambuildTargetUser.find_by(user_id: user.id)).to be_blank
      end

      it "updates the object" do
        put "/team-build/targets/#{target.id}.json",
            params: {
              teambuild_target: {
                name: "updated name",
              },
            }
        expect(response.code).to eq("200")
        json = JSON.parse(response.body)
        expect(json).to be_present
        expect(json["teambuild_target"]).to be_present
        expect(json["teambuild_target"]["name"]).to eq("updated name")
      end

      it "can swap the position of targets" do
        other =
          TeambuildTarget.create!(
            target_type_id: TeambuildTarget.target_types[:regular],
            name: "another",
          )
        other_position = other.position
        target_position = target.position

        put "/team-build/targets/#{target.id}/swap-position.json", params: { other_id: other.id }
        expect(response.code).to eq("200")
        expect(target.reload.position).to eq(other_position)
        expect(other.reload.position).to eq(target_position)
      end
    end
  end
end
