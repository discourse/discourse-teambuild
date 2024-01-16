import { popupAjaxError } from "discourse/lib/ajax-error";
import RestModel from "discourse/models/rest";

function choiceKey(target, userId) {
  return `${target.id}:${userId}`;
}

export default RestModel.extend({
  isComplete(target, userId) {
    return this.completed.includes(choiceKey(target, userId));
  },

  complete(target, userId) {
    target
      .complete(userId)
      .then(() => {
        this.completed.addObject(choiceKey(target, userId));
      })
      .catch(popupAjaxError);
  },

  undo(target, userId) {
    target
      .undo(userId)
      .then(() => {
        this.completed.removeObject(choiceKey(target, userId));
      })
      .catch(popupAjaxError);
  },
});
