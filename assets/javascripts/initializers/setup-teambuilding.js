import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "setup-teambuilding",
  initialize() {
    withPluginApi("0.8", (api) => {
      const currentUser = api.getCurrentUser();
      if (currentUser?.can_access_teambuild) {
        api.addCommunitySectionLink((baseSectionLink) => {
          return class TeambuildSectionLink extends baseSectionLink {
            name = "team-building";
            route = "teamBuild.progress";
            text = this.siteSettings.teambuild_name;
            title = this.siteSettings.teambuild_name;
          };
        });
      }
    });
  },
};
