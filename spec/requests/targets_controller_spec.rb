# frozen_string_literal: true

require "rails_helper"

describe DiscourseTeambuild::TargetsController do

  it "returns 403 when anonymous" do
    SiteSetting.teambuild_enabled = true
    get "/team-build/targets.json"
    expect(response.code).to eq("403")
  end

  context "logged in" do
    before do
      SiteSetting.teambuild_enabled = true
      sign_in(Fabricate(:user))
    end

    context "enabled/disabled" do
      fab!(:target) { TeambuildTarget.create!(target_type_id: 1, name: 'cool') }

      it "returns 403 when disabled" do
        SiteSetting.teambuild_enabled = false
        get "/team-build/targets.json"
        expect(response.code).to eq("403")
      end

      context "index" do
        it "returns json" do
          get "/team-build/targets.json"
          expect(response.code).to eq("200")
          json = JSON.parse(response.body)
          expect(json).to be_present
          json_target = json['teambuild_targets'].find { |t| t['id'] == target.id }

          expect(json_target).to be_present
          expect(json_target['name']).to eq(target.name)
          expect(json_target['target_type_id']).to eq(target.target_type_id)
        end
      end

      context "create" do
        it "returns json" do
          post "/team-build/targets.json", params: {
            teambuild_target: { name: 'cool target name', target_type_id: 1 }
          }
          expect(response.code).to eq("200")
          json = JSON.parse(response.body)
          expect(json).to be_present
          expect(json['teambuild_target']).to be_present
          expect(json['teambuild_target']['name']).to eq('cool target name')
        end
      end

      context "destroy" do
        it "returns json" do
          id = target.id
          delete "/team-build/targets/#{id}.json"
          expect(response.code).to eq("200")
          expect(TeambuildTarget.find_by(id: id)).to be_blank
        end
      end
    end

  end

end
