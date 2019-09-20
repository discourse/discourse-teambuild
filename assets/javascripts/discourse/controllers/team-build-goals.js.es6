import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";

export default Ember.Controller.extend({
  goals: null,
  completed: null,

  actions: {
    complete(goal) {
      ajax(`/team-build/complete/${goal.id}`, { method: "PUT" })
        .then(() => {
          this.completed.addObject(goal.id);
          this.set("completed", this.completed.slice(0));
        })
        .catch(popupAjaxError);
    },
    undo(goal) {
      ajax(`/team-build/undo/${goal.id}`, { method: "DELETE" })
        .then(() => {
          this.completed.removeObject(goal.id);
          this.set("completed", this.completed.slice(0));
        })
        .catch(popupAjaxError);
    }
  }
});
