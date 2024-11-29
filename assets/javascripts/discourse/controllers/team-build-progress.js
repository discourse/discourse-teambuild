import Controller from "@ember/controller";
import { propertyNotEqual } from "discourse/lib/computed";

export default class TeamBuildProgressController extends Controller {
  @propertyNotEqual("currentUser.id", "progress.user.id") readOnly;
}
