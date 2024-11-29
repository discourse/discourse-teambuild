import Component from "@ember/component";
import { action, computed } from "@ember/object";
import { tagName } from "@ember-decorators/component";

@tagName("")
export default class TeambuildChoice extends Component {
  @computed("progress.completed.[]")
  get completed() {
    return this.progress.isComplete(this.target, this.userId);
  }

  @action
  complete() {
    this.progress.complete(this.target, this.userId);
  }

  @action
  undo() {
    this.progress.undo(this.target, this.userId);
  }
}
