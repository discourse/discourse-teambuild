import RestAdapter from "discourse/adapters/rest";

export default class TeambuildTargetAdapter extends RestAdapter {
  jsonMode = true;
  pathFor(store, type, id) {
    if (id) {
      return `/team-build/targets/${id}.json`;
    }
    return `/team-build/targets.json`;
  }
}
