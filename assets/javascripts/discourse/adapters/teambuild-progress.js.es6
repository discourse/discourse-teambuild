import RestAdapter from "discourse/adapters/rest";

export default RestAdapter.extend({
  jsonMode: true,
  pathFor(store, type, username) {
    return `/team-build/progress/${username}.json`;
  }
});
