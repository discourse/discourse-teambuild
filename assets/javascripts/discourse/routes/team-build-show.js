import Route from "@ember/routing/route";

export default class TeamBuildShowRoute extends Route {
  model(params) {
    return this.store.find("teambuild-progress", params.username);
  }

  setupController(controller, progress) {
    this.controllerFor("teamBuild.progress").setProperties({ progress });
  }

  renderTemplate() {
    this.render("teamBuild.progress");
  }
}
