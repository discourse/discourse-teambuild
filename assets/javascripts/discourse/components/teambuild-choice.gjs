import Component from "@ember/component";
import { action } from "@ember/object";
import { tagName } from "@ember-decorators/component";
import DButton from "discourse/components/d-button";
import icon from "discourse/helpers/d-icon";

@tagName("")
export default class TeambuildChoice extends Component {
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

  <template>
    <div
      class="teambuild-choice {{if this.completed 'completed' 'incomplete'}}"
    >
      <div class="controls">
        {{#if this.readOnly}}
          {{#if this.completed}}
            {{icon "check"}}
          {{/if}}
        {{else}}
          {{#if this.completed}}
            <DButton
              @icon="check"
              @action={{this.undo}}
              @title="discourse_teambuild.progress.mark_incomplete"
              class="btn-primary"
            />
          {{else}}
            <DButton
              @icon="circle"
              @action={{this.complete}}
              @title="discourse_teambuild.progress.mark_complete"
            />
          {{/if}}
        {{/if}}
      </div>
      <div class="choice-label">{{this.label}}</div>
    </div>
  </template>
}
