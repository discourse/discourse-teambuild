import Route from "@ember/routing/route";

export default Route.extend({
  model() {
    return this.store.find("teambuild-progress", this.currentUser.username);
  },

  setupController(controller, progress) {
    controller.setProperties({ progress });
  },
});
