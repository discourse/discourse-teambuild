export default Ember.Controller.extend({
  goals: null,
  completed: null,

  actions: {
    complete(goal) {
      if (goal) {
        this.completed.addObject(goal.id);
        this.set("completed", this.completed.slice(0));
      }
    },
    undo(goal) {
      if (goal) {
        this.completed.removeObject(goal.id);
        this.set("completed", this.completed.slice(0));
      }
    }
  }
});
