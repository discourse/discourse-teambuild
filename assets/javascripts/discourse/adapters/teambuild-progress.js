import RestAdapter from "discourse/adapters/rest";

export default class TeambuildProgressAdapter extends RestAdapter {
  jsonMode = true;
  pathFor(store, type, username) {
    return `/team-build/progress/${username}.json`;
  }
}
