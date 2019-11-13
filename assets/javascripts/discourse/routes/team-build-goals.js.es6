import { ajax } from "discourse/lib/ajax";
import Route from "@ember/routing/route";

export default Route.extend({
  model() {
    return ajax("/team-build/goals.json");
  },

  setupController(controller, model) {
    controller.setProperties(model);
  }
});
