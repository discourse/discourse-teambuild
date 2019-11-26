# frozen_string_literal: true

require "rails_helper"

describe DiscourseTeambuild::TeambuildController do

  it "returns 403 when anonymous" do
    SiteSetting.teambuild_enabled = true
    get "/team-build/about.json"
    expect(response.code).to eq("403")
  end

  context "logged in" do
    before do
      SiteSetting.teambuild_enabled = true
      sign_in(Fabricate(:user))
    end

    context "enabled/disabled" do
      it "returns 403 when disabled" do
        SiteSetting.teambuild_enabled = false
        get "/team-build/about.json"
        expect(response.code).to eq("403")
      end

      it "returns 200 when enabled" do
        get "/team-build/about.json"
        expect(response.code).to eq("200")
      end
    end

    context "progress" do
      it "returns nothing when no progress" do
        get "/team-build/progress.json"
        json = JSON.parse(response.body)
        expect(json).to be_present
        expect(json['teambuild_progress']).to be_present
      end
    end
  end

end
