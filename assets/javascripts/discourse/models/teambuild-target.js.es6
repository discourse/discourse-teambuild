import RestModel from "discourse/models/rest";
import { ajax } from "discourse/lib/ajax";

export const Types = {
  REGULAR: 1,
  USER_GROUP: 2
};

export default RestModel.extend({
  swapPosition(other) {
    let tmp = this.position;
    this.set("position", other.position);
    other.set("position", tmp);

    return ajax(`/team-build/targets/${this.id}/swap-position`, {
      method: "PUT",
      data: { other_id: other.id }
    });
  },

  complete(userId) {
    return ajax(`/team-build/complete/${this.id}/${userId}`, {
      method: "PUT"
    });
  },

  undo(userId) {
    return ajax(`/team-build/undo/${this.id}/${userId}`, {
      method: "DELETE"
    });
  }
});
