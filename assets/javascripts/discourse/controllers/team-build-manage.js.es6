import Controller from "@ember/controller";
import { Types } from "discourse/plugins/discourse-teambuild/discourse/models/teambuild-target";
import { sort } from "@ember/object/computed";

export default Controller.extend({
  targets: null,

  targetSort: ["position"],

  sortedTargets: sort("targets", "targetSort"),

  actions: {
    move(idx, direction) {
      let item = this.sortedTargets[idx];
      let other = this.sortedTargets[idx + direction];
      if (item && other) {
        item.swapPosition(other);
      }
    },

    newTarget() {
      let maxPosition = 0;
      if (this.targets.length > 0) {
        maxPosition = Math.max(...this.targets.map(t => t.position));
      }
      this.targets.pushObject(
        this.store.createRecord("teambuild-target", {
          target_type_id: Types.REGULAR,
          position: maxPosition + 1
        })
      );
    },

    removeTarget(t) {
      this.targets.removeObject(t);
    }
  }
});
