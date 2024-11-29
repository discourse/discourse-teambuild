import Controller from "@ember/controller";
import { action } from "@ember/object";
import { sort } from "@ember/object/computed";
import { Types } from "discourse/plugins/discourse-teambuild/discourse/models/teambuild-target";

export default class TeamBuildManageController extends Controller {
  targets = null;
  targetSort = ["position"];

  @sort("targets", "targetSort") sortedTargets;

  @action
  move(idx, direction) {
    let item = this.sortedTargets[idx];
    let other = this.sortedTargets[idx + direction];
    if (item && other) {
      item.swapPosition(other);
    }
  }

  @action
  newTarget() {
    let maxPosition = 0;
    if (this.targets.length > 0) {
      maxPosition = Math.max(...this.targets.map((t) => t.position));
    }
    this.targets.pushObject(
      this.store.createRecord("teambuild-target", {
        target_type_id: Types.REGULAR,
        position: maxPosition + 1,
      })
    );
  }

  @action
  removeTarget(t) {
    this.targets.removeObject(t);
  }
}
