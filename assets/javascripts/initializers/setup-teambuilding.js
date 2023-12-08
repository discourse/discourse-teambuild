import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "setup-teambuilding",
  initialize() {
    withPluginApi("0.8", (api) => {
      const currentUser = api.getCurrentUser();
      if (currentUser?.can_access_teambuild) {
        api.addCommunitySectionLink((baseSectionLink) => {
          return class TeambuildSectionLink extends baseSectionLink {
            get name() {
              return "team-building";
            }

            get route() {
              return "teamBuild.progress";
            }

            get text() {
              return this.siteSettings.teambuild_name;
            }

            get title() {
              return this.siteSettings.teambuild_name;
            }
          };
        });
      }
    });
  },
};
