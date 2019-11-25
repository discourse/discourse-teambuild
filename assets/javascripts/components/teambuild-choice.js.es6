import Component from "@ember/component";
import { computed } from "@ember/object";

export default Component.extend({
  tagName: "",

  completed: computed("progress.completed.[]", function() {
    return this.progress.isComplete(this.target, this.userId);
  }),

  actions: {
    complete() {
      this.progress.complete(this.target, this.userId);
    },
    undo() {
      this.progress.undo(this.target, this.userId);
    }
  }
});
