export default Ember.Route.extend({
  model() {
    return ajax("/team-build/goals.json");
  }
});
