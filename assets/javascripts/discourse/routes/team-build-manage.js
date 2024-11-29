import Route from "@ember/routing/route";

export default class TeamBuildManageRoute extends Route {
  model() {
    return this.store.findAll("teambuild-target");
  }

  setupController(controller, targets) {
    controller.setProperties({ targets, groups: targets.extras.groups });
  }
}
