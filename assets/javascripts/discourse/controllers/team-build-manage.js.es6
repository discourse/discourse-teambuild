import Controller from "@ember/controller";
import { Types } from "discourse/plugins/discourse-teambuild/discourse/models/teambuild-target";
import { sort } from "@ember/object/computed";

export default Controller.extend({
  targets: null,

  sortedTargets: sort("targets", function(a, b) {
    return a.position - b.position;
  }),

  actions: {
    newTarget() {
      this.targets.pushObject(
        this.store.createRecord("teambuild-target", {
          target_type_id: Types.REGULAR
        })
      );
    },

    removeTarget(t) {
      this.targets.removeObject(t);
    }
  }
});
