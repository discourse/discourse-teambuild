import Controller from "@ember/controller";
import { Types } from "discourse/plugins/discourse-teambuild/discourse/models/teambuild-target";

export default Controller.extend({
  targets: null,

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
