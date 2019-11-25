import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "setup-teambuilding",
  initialize() {
    withPluginApi("0.8", api => {
      api.decorateWidget("hamburger-menu:generalLinks", () => {
        return {
          icon: "campground",
          route: "teamBuild.progress",
          label: "discourse_teambuild.title"
        };
      });
    });
  }
};
