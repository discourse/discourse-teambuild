import Component from "@ember/component";
import { action, computed } from "@ember/object";
import { equal, or } from "@ember/object/computed";
import { underscore } from "@ember/string";
import { tagName } from "@ember-decorators/component";
import { popupAjaxError } from "discourse/lib/ajax-error";
import { bufferedProperty } from "discourse/mixins/buffered-content";
import { Types } from "discourse/plugins/discourse-teambuild/discourse/models/teambuild-target";

@tagName("")
export default class TeambuildTarget extends Component.extend(
  bufferedProperty("target")
) {
  editSelected = false;

  @equal("buffered.target_type_id", Types.USER_GROUP) needsGroup;
  @or("editSelected", "target.isNew") editing;

  @computed("editing", "index")
  get canMoveUp() {
    return !this.editing && this.index > 0;
  }

  @computed("editing", "index", "length")
  get canMoveDown() {
    return !this.editing && this.index < this.length - 1;
  }

  @computed
  get targetTypes() {
    return Object.keys(Types).map((key) => {
      return { id: Types[key], name: underscore(key) };
    });
  }

  @computed(
    "buffered.name",
    "target.isSaving",
    "needsGroup",
    "buffered.group_id"
  )
  get saveDisabled() {
    if (this.target.isSaving) {
      return true;
    }

    let name = this.get("buffered.name");
    if (!name || name.length === 0) {
      return true;
    }

    if (this.needsGroup && !this.get("buffered.group_id")) {
      return true;
    }

    return false;
  }

  @action
  save() {
    this.target
      .save(this.buffered.getProperties("name", "target_type_id", "group_id"))
      .then(() => {
        this.set("editSelected", false);
      })
      .catch(popupAjaxError);
  }

  @action
  cancel() {
    if (this.target.isNew) {
      return this.removeTarget();
    } else {
      this.set("editSelected", false);
      this.rollbackBuffer();
    }
  }

  @action
  destroy() {
    this.target.destroyRecord().then(() => this.removeTarget());
  }
}
