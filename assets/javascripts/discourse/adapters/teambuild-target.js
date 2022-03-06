import RestAdapter from "discourse/adapters/rest";

export default RestAdapter.extend({
  jsonMode: true,
  pathFor(store, type, id) {
    if (id) {
      return `/team-build/targets/${id}.json`;
    }
    return `/team-build/targets.json`;
  },
});
