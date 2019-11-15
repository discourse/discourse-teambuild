import Component from "@ember/component";
import { computed } from "@ember/object";
import { Types } from "discourse/plugins/discourse-teambuild/discourse/models/teambuild-target";
import { bufferedProperty } from "discourse/mixins/buffered-content";
import { underscore } from "@ember/string";

export default Component.extend(bufferedProperty("target"), {
  tagName: "",

  targetTypes: computed(function() {
    return Object.keys(Types).map(key => {
      return { id: Types[key], name: underscore(key) };
    });
  }),

  showControls: computed("target.isNew", function() {
    return this.target.isNew;
  }),

  saveDisabled: computed("target.name", function() {
    return !this.target.name || this.target.name.length === 0;
  }),

  actions: {
    save() {
      console.log("save it");
    }
  }
});
