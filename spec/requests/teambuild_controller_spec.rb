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
      sign_in(Fabricate(:user))
    end

    it "returns 403 when disabled" do
      get "/team-build/about.json"
      expect(response.code).to eq("403")
    end

    it "returns 200 when enabled" do
      SiteSetting.teambuild_enabled = true
      get "/team-build/about.json"
      expect(response.code).to eq("200")
    end
  end

end
