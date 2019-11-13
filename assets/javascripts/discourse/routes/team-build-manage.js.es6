import Route from "@ember/routing/route";

export default Route.extend({
  model() {
    return this.store.findAll("teambuild-target");
  },

  setupController(controller, targets) {
    controller.setProperties({ targets });
  }
});
