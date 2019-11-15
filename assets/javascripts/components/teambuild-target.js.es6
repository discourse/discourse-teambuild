import Component from "@ember/component";
import { computed } from "@ember/object";
import { Types } from "discourse/plugins/discourse-teambuild/discourse/models/teambuild-target";
import { bufferedProperty } from "discourse/mixins/buffered-content";
import { underscore } from "@ember/string";
import { or } from "@ember/object/computed";

export default Component.extend(bufferedProperty("target"), {
  tagName: "",
  editing: false,

  showFields: or("editing", "target.isNew"),

  targetTypes: computed(function() {
    return Object.keys(Types).map(key => {
      return { id: Types[key], name: underscore(key) };
    });
  }),

  saveDisabled: computed("buffered.name", "target.isSaving", function() {
    if (this.target.isSaving) {
      return true;
    }
    let name = this.get("buffered.name");
    return !name || name.length === 0;
  }),

  actions: {
    save() {
      this.target.save(this.buffered.getProperties("name", "target_type_id"));
    },
    cancel() {
      if (this.target.isNew) {
        return this.attrs.removeTarget();
      }
    },
    destroy() {
      this.target.destroyRecord().then(() => this.attrs.removeTarget());
    }
  }
});
