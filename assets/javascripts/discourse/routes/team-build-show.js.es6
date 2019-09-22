import { ajax } from "discourse/lib/ajax";

export default Ember.Route.extend({
  model(params) {
    return ajax(`/team-build/goals/${params.username}.json`);
  },

  setupController(controller, model) {
    this.controllerFor("teamBuild.goals").setProperties(model);
  },

  renderTemplate() {
    this.render("teamBuild.goals");
  }
});
