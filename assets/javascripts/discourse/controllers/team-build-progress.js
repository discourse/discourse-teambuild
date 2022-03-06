import Controller from "@ember/controller";
import { propertyNotEqual } from "discourse/lib/computed";

export default Controller.extend({
  readOnly: propertyNotEqual("currentUser.id", "progress.user.id"),
});
