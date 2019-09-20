import { ajax } from "discourse/lib/ajax";

export default Ember.Route.extend({
  model() {
    return ajax("/team-build/goals.json");
  },

  setupController(controller, model) {
    controller.setProperties(model);
  }
});
