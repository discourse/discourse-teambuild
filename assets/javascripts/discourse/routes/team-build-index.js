import Route from "@ember/routing/route";
import { ajax } from "discourse/lib/ajax";

export default Route.extend({
  model() {
    return ajax("/team-build/scores.json");
  },

  setupController(controller, model) {
    controller.set("scores", model.scores);
  },
});
