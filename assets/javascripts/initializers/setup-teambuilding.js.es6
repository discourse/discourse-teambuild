import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "setup-teambuilding",
  initialize() {
    withPluginApi("0.8", api => {
      const currentUser = api.getCurrentUser();
      if (currentUser && currentUser.can_access_teambuild) {
        api.decorateWidget("hamburger-menu:generalLinks", dec => {
          return {
            route: "teamBuild.progress",
            rawLabel: dec.widget.siteSettings.teambuild_name
          };
        });
      }
    });
  }
};
