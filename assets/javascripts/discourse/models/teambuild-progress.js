import { popupAjaxError } from "discourse/lib/ajax-error";
import {
  addUniqueValueToArray,
  removeValueFromArray,
} from "discourse/lib/array-tools";
import { trackedArray } from "discourse/lib/tracked-tools";
import RestModel from "discourse/models/rest";

function choiceKey(target, userId) {
  return `${target.id}:${userId}`;
}

export default class TeambuildProgress extends RestModel {
  @trackedArray completed = [];

  isComplete(target, userId) {
    return this.completed.includes(choiceKey(target, userId));
  }

  complete(target, userId) {
    target
      .complete(userId)
      .then(() => {
        addUniqueValueToArray(this.completed, choiceKey(target, userId));
      })
      .catch(popupAjaxError);
  }

  undo(target, userId) {
    target
      .undo(userId)
      .then(() => {
        removeValueFromArray(this.completed, choiceKey(target, userId));
      })
      .catch(popupAjaxError);
  }
}
