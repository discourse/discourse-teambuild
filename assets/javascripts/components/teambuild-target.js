import Component from "@ember/component";
import { computed } from "@ember/object";
import { equal, or } from "@ember/object/computed";
import { underscore } from "@ember/string";
import { popupAjaxError } from "discourse/lib/ajax-error";
import { bufferedProperty } from "discourse/mixins/buffered-content";
import { Types } from "discourse/plugins/discourse-teambuild/discourse/models/teambuild-target";

export default Component.extend(bufferedProperty("target"), {
  tagName: "",
  editSelected: false,

  needsGroup: equal("buffered.target_type_id", Types.USER_GROUP),

  canMoveUp: computed("editing", "index", function () {
    return !this.editing && this.index > 0;
  }),

  canMoveDown: computed("editing", "index", "length", function () {
    return !this.editing && this.index < this.length - 1;
  }),

  editing: or("editSelected", "target.isNew"),

  targetTypes: computed(function () {
    return Object.keys(Types).map((key) => {
      return { id: Types[key], name: underscore(key) };
    });
  }),

  saveDisabled: computed(
    "buffered.name",
    "target.isSaving",
    "needsGroup",
    "buffered.group_id",
    function () {
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
  ),

  actions: {
    save() {
      this.target
        .save(this.buffered.getProperties("name", "target_type_id", "group_id"))
        .then(() => {
          this.set("editSelected", false);
        })
        .catch(popupAjaxError);
    },
    cancel() {
      if (this.target.isNew) {
        return this.removeTarget();
      } else {
        this.set("editSelected", false);
        this.rollbackBuffer();
      }
    },
    destroy() {
      this.target.destroyRecord().then(() => this.removeTarget());
    },
  },
});
