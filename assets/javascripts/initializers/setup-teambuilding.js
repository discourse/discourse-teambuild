import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "setup-teambuilding",
  initialize() {
    withPluginApi("0.8", (api) => {
      const currentUser = api.getCurrentUser();
      const teamBuildName = api.container.lookup(
        "service:site-settings"
      ).teambuild_name;
      if (currentUser && currentUser.can_access_teambuild) {
        api.decorateWidget("hamburger-menu:generalLinks", () => {
          return {
            route: "teamBuild.progress",
            rawLabel: teamBuildName,
          };
        });
      }
    });
  },
};
